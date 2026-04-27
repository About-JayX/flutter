import { Controller, Get, Post, Delete, Body, Query, Param, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { FeedService } from './feed.service';
import { CreatePostDto } from './dto/create-post.dto';
import { FeedQueryDto } from './dto/feed-query.dto';
import { LikePostDto } from './dto/like-post.dto';
import { CreateCommentDto } from './dto/create-comment.dto';
import { CommentQueryDto } from './dto/comment-query.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';

@ApiTags('广场')
@Controller('feed')
export class FeedController {
  private readonly logger = new Logger(FeedController.name);

  constructor(private readonly feedService: FeedService) {}

  @Post('post')
  @ApiOperation({ summary: '发布帖子' })
  async createPost(
    @CurrentUser() user: any,
    @Body() createPostDto: CreatePostDto,
  ) {
    return this.feedService.createPost(user.uniqid, createPostDto);
  }

  @Get('posts')
  @ApiOperation({ summary: '获取广场信息流' })
  async getFeed(@CurrentUser() user: any, @Query() query: FeedQueryDto) {
    const result = await this.feedService.getFeed(user.uniqid, query);
    return {
      status: '0',
      statusInfo: 'success',
      data: {
        posts: result.posts,
        total: result.total,
      },
    };
  }

  @Post('like')
  @ApiOperation({ summary: '点赞/取消点赞帖子' })
  async likePost(@CurrentUser() user: any, @Body() likePostDto: LikePostDto) {
    await this.feedService.likePost(user.uniqid, likePostDto.postId);
    return { status: '0', statusInfo: '操作成功' };
  }

  @Post('apply-friend')
  @ApiOperation({ summary: '申请好友' })
  async applyFriend(
    @CurrentUser() user: any,
    @Body('targetId') targetId: string,
  ) {
    await this.feedService.applyFriend(user.uniqid, targetId);
    return { status: '0', statusInfo: '申请已发送' };
  }

  @Post('not-interested')
  @ApiOperation({ summary: '不感兴趣' })
  async notInterested(
    @CurrentUser() user: any,
    @Body('postId') postId: string,
  ) {
    await this.feedService.notInterested(user.uniqid, postId);
    return { status: '0', statusInfo: '已记录' };
  }

  @Post('comment')
  @ApiOperation({ summary: '发表评论' })
  async createComment(
    @CurrentUser() user: any,
    @Body() createCommentDto: CreateCommentDto,
  ) {
    return this.feedService.createComment(user.uniqid, createCommentDto);
  }

  @Get('comments')
  @ApiOperation({ summary: '获取评论列表' })
  async getComments(
    @Query('postId') postId: string,
    @Query() query: CommentQueryDto,
  ) {
    return this.feedService.getComments(postId, query);
  }

  @Delete('comment/:id')
  @ApiOperation({ summary: '删除评论' })
  async deleteComment(
    @CurrentUser() user: any,
    @Param('id') commentId: string,
  ) {
    await this.feedService.deleteComment(user.uniqid, commentId);
    return { status: '0', statusInfo: '评论已删除' };
  }
}
