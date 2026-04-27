import {
  Injectable,
  Logger,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Inject } from '@nestjs/common';
import type { Cache } from 'cache-manager';
import { Post } from './entities/post.entity';
import { Comment } from './entities/comment.entity';
import { CreatePostDto } from './dto/create-post.dto';
import { FeedQueryDto } from './dto/feed-query.dto';
import { CreateCommentDto } from './dto/create-comment.dto';
import { CommentQueryDto } from './dto/comment-query.dto';
import { Swipe } from '../match/entities/swipe.entity';
import { Friendship } from '../match/entities/friendship.entity';
import { Block } from '../block/entities/block.entity';
import { UsersService } from '../users/users.service';
import { ModerationService } from './services/moderation.service';

@Injectable()
export class FeedService {
  private readonly logger = new Logger(FeedService.name);

  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(Comment)
    private readonly commentRepository: Repository<Comment>,
    @InjectRepository(Swipe)
    private readonly swipeRepository: Repository<Swipe>,
    @InjectRepository(Friendship)
    private readonly friendshipRepository: Repository<Friendship>,
    @InjectRepository(Block)
    private readonly blockRepository: Repository<Block>,
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache,
    private readonly usersService: UsersService,
    private readonly moderationService: ModerationService,
  ) {}

  async createPost(
    userId: string,
    createPostDto: CreatePostDto,
  ): Promise<Post> {
    const moderationResult = await this.moderationService.moderateContent(
      createPostDto.content,
      userId,
    );

    const post = this.postRepository.create({
      userId,
      content: createPostDto.content,
      tags: createPostDto.tags,
      purpose: createPostDto.purpose,
      visibility: createPostDto.visibility || 'public',
      images: createPostDto.images,
      isAnonymous: createPostDto.isAnonymous ? 1 : 0,
      status: moderationResult.status,
      moderationReason: moderationResult.reason,
    });

    const savedPost = await this.postRepository.save(post);
    await this.updateFeedCache(userId);

    return savedPost;
  }

  async getFeed(userId: string, query: FeedQueryDto): Promise<{ posts: any[]; total: number }> {
    const page = query.page || 1;
    const limit = query.limit || 12;

    const queryBuilder = this.postRepository
      .createQueryBuilder('post')
      .where('post.status = :status', { status: 'approved' })
      .orderBy('post.createdAt', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);

    const [posts, total] = await queryBuilder.getManyAndCount();

    const userIds = [...new Set(posts.map(p => p.userId))];
    const users = await this.usersService.findByUniqids(userIds);
    const userMap = new Map(users.map(u => [u.uniqid, u]));

    const enrichedPosts = posts.map(post => {
      const user = userMap.get(post.userId);
      return {
        ...post,
        username: user?.userNickName || user?.userName || 'Anonymous',
        avatar: user?.avatar || null,
        isLiked: false,
      };
    });

    return { posts: enrichedPosts, total };
  }

  async likePost(userId: string, postId: string): Promise<void> {
    const post = await this.postRepository.findOne({ where: { id: postId } });
    if (!post) {
      throw new NotFoundException('帖子不存在');
    }

    const likeKey = `like:${userId}:${postId}`;
    const hasLiked = await this.cacheManager.get<boolean>(likeKey);

    if (hasLiked) {
      post.likeCount = Math.max(0, post.likeCount - 1);
      await this.cacheManager.del(likeKey);
    } else {
      post.likeCount += 1;
      await this.cacheManager.set(likeKey, true, 86400);
    }

    await this.postRepository.save(post);
  }

  async applyFriend(userId: string, targetId: string): Promise<void> {
    const today = new Date().toISOString().split('T')[0];
    const applyKey = `apply:${userId}:${today}`;
    const applyCount = (await this.cacheManager.get<number>(applyKey)) || 0;

    const user = await this.usersService.getProfile(userId);
    const maxApplies = user.isVIP ? 100 : 6;

    if (applyCount >= maxApplies) {
      throw new BadRequestException('今日申请次数已达上限，请明日再试');
    }

    const existing = await this.friendshipRepository.findOne({
      where: [
        { userId, friendId: targetId },
        { userId: targetId, friendId: userId },
      ],
    });

    if (existing) {
      throw new BadRequestException('已存在好友关系');
    }

    const friendship = this.friendshipRepository.create({
      userId,
      friendId: targetId,
      status: 'pending',
    });

    await this.friendshipRepository.save(friendship);
    await this.cacheManager.set(applyKey, applyCount + 1, 86400);
  }

  async notInterested(userId: string, postId: string): Promise<void> {
    const key = `not_interested:${userId}`;
    const notInterestedList =
      (await this.cacheManager.get<string[]>(key)) || [];
    notInterestedList.push(postId);
    await this.cacheManager.set(key, notInterestedList, 86400 * 7);
  }

  async createComment(
    userId: string,
    createCommentDto: CreateCommentDto,
  ): Promise<Comment> {
    const post = await this.postRepository.findOne({
      where: { id: createCommentDto.postId },
    });

    if (!post) {
      throw new NotFoundException('帖子不存在');
    }

    const moderationResult = await this.moderationService.moderateContent(
      createCommentDto.content,
      userId,
    );

    const comment = this.commentRepository.create({
      postId: createCommentDto.postId,
      userId,
      content: createCommentDto.content,
      parentId: createCommentDto.parentId,
      status: moderationResult.status,
    });

    const savedComment = await this.commentRepository.save(comment);

    if (moderationResult.status === 'approved') {
      post.commentCount += 1;
      await this.postRepository.save(post);
      await this.cacheManager.del(`feed:${userId}:*`);
    }

    return savedComment;
  }

  async getComments(
    postId: string,
    query: CommentQueryDto,
  ): Promise<{ comments: Comment[]; total: number }> {
    const page = query.page || 1;
    const limit = query.limit || 20;

    const [comments, total] = await this.commentRepository.findAndCount({
      where: { postId, status: 'approved' },
      order: { createdAt: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    return { comments, total };
  }

  async deleteComment(userId: string, commentId: string): Promise<void> {
    const comment = await this.commentRepository.findOne({
      where: { id: commentId },
    });

    if (!comment) {
      throw new NotFoundException('评论不存在');
    }

    if (comment.userId !== userId) {
      throw new BadRequestException('只能删除自己的评论');
    }

    await this.commentRepository.delete({ id: commentId });

    const post = await this.postRepository.findOne({
      where: { id: comment.postId },
    });

    if (post) {
      post.commentCount = Math.max(0, post.commentCount - 1);
      await this.postRepository.save(post);
    }
  }

  private async updateFeedCache(userId: string): Promise<void> {
    const patterns = [`feed:${userId}:*`, `feed:all:*`];
    for (const pattern of patterns) {
      const keys = await (this.cacheManager as any).store.keys(pattern);
      for (const key of keys) {
        await this.cacheManager.del(key);
      }
    }
  }

  private async getBlockedUsers(userId: string): Promise<string[]> {
    const blocks = await this.blockRepository.find({
      where: { userId },
      select: ['blockedId'],
    });
    return blocks.map((b) => b.blockedId);
  }

  private async getFriendIds(userId: string): Promise<string[]> {
    const friendships = await this.friendshipRepository.find({
      where: [
        { userId, status: 'accepted' },
        { friendId: userId, status: 'accepted' },
      ],
      select: ['userId', 'friendId'],
    });

    return friendships.map((f) =>
      f.userId === userId ? f.friendId : f.userId,
    );
  }
}
