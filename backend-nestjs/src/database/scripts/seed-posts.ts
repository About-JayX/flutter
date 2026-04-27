import { DataSource } from 'typeorm';
import * as dotenv from 'dotenv';
import * as fs from 'fs';
import * as path from 'path';
import { Post } from '../../modules/feed/entities/post.entity';
import { User } from '../../modules/users/entities/user.entity';

const env = process.env.NODE_ENV || 'dev';
const envFile = `.env.${env}`;
const envPath = path.join(__dirname, '../../../', envFile);

if (fs.existsSync(envPath)) {
  dotenv.config({ path: envPath });
}

const AppDataSource = new DataSource({
  type: 'mysql',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '3306', 10),
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  charset: 'utf8mb4_unicode_ci',
  synchronize: false,
  entities: [Post, User],
  logging: false,
});

async function seedPosts() {
  await AppDataSource.initialize();

  const postRepository = AppDataSource.getRepository(Post);
  const userRepository = AppDataSource.getRepository(User);

  const users = await userRepository.find({
    select: ['uniqid'],
    take: 100,
  });

  if (users.length === 0) {
    console.error('No users found in database');
    process.exit(1);
  }

  const userIds = users.map((u) => u.uniqid);

  const contents = [
    'Looking for someone to explore the city with this weekend! 🌆',
    'Just finished reading a great book. Any recommendations? 📚',
    'Coffee lover seeking fellow caffeine enthusiasts ☕',
    'Who wants to join me for a hike this Saturday? 🥾',
    'New to the city, looking for friends to show me around 🗺️',
    'Music festival next month! Anyone interested? 🎵',
    'Foodie here! Let\'s discover new restaurants together 🍜',
    'Gym buddy wanted for morning workouts 💪',
    'Love photography! Let\'s go on a photo walk 📸',
    'Board game night at my place this Friday 🎲',
    'Looking for a tennis partner 🎾',
    'Want to learn Spanish, anyone interested in language exchange? 🇪🇸',
    'Movie buff seeking cinema companions 🎬',
    'Yoga enthusiast looking for practice partners 🧘',
    'Dog owner seeking playdates for our furry friends 🐕',
    'Art gallery hopping this Sunday? 🎨',
    'Cooking class enthusiast, let\'s learn together 👨‍🍳',
    'Beach volleyball anyone? 🏐',
    'Book club starting next week, join us! 📖',
    'Looking for study buddies for coding interviews 💻',
    'Wine tasting event this weekend 🍷',
    'Karaoke night! Who\'s in? 🎤',
    'Want to start a running group 🏃',
    'Potluck dinner at my place next Saturday 🍽️',
    'Looking for a climbing partner 🧗',
    'Game night! Board games and snacks 🎯',
    'Interested in starting a podcast, co-host wanted 🎙️',
    'Dance class partner needed 💃',
    'Plant parent seeking fellow green thumbs 🌱',
    'Baking enthusiast, let\'s exchange recipes 🧁',
    'Soccer team looking for players ⚽',
    'Want to explore local breweries 🍺',
    'Comedy show this Thursday, join me! 😄',
    'Looking for a badminton partner 🏸',
    'Meditation group forming, interested? 🧘‍♂️',
    'DIY project enthusiasts, let\'s collaborate 🔨',
    'Fishing trip planned for next weekend 🎣',
    'Want to learn salsa dancing 💃🕺',
    'Trivia night team needed 🧠',
    'Looking for cycling buddies 🚴',
    'Pottery class this month, join me! 🏺',
    'Chess player seeking opponents ♟️',
    'Want to start a book club 📚',
    'Hiking group planning a trip 🏔️',
    'Looking for a squash partner 🎾',
    'Craft beer tasting tour 🍻',
    'Stand-up comedy open mic night 🎭',
    'Want to learn how to surf 🏄',
    'Pizza making class this weekend 🍕',
    'Looking for a ping pong partner 🏓',
    'Escape room challenge! Who\'s in? 🔐',
    'Want to explore local farmers markets 🥕',
    'Sushi rolling class 🍣',
    'Looking for a golf buddy ⛳',
    'Improv comedy workshop 🎪',
    'Want to start a hiking group 🥾',
    'Ice skating this winter? ⛸️',
    'Looking for a bowling team 🎳',
    'Cooking competition at my place 👨‍🍳',
    'Want to learn how to skateboard 🛹',
    'Poetry reading night 📜',
    'Looking for a squash partner 🏸',
    'Wine and paint night 🎨',
    'Want to explore local coffee shops ☕',
    'Tennis lessons, partner wanted 🎾',
    'Looking for a racquetball partner 🏸',
    'Comedy club visit this weekend 😂',
    'Want to learn how to ski ⛷️',
    'Board game cafe meetup 🎲',
    'Looking for a pool buddy 🎱',
    'Food truck festival this month 🌮',
    'Want to start a running club 🏃‍♀️',
    'Axe throwing experience! 🪓',
    'Looking for a frisbee golf partner 🥏',
    'Trivia night at local pub 🍻',
    'Want to learn how to rock climb 🧗‍♀️',
    'Salsa dancing lessons 💃',
    'Looking for a kayaking partner 🛶',
    'Escape room adventure 🔍',
    'Want to explore local wineries 🍇',
    'Ping pong tournament 🏓',
    'Looking for a bocce ball team 🎱',
    'Curling experience this winter 🥌',
    'Want to learn how to snowboard 🏂',
    'Darts night at the pub 🎯',
    'Looking for a shuffleboard partner 🎱',
    'Mini golf anyone? ⛳',
    'Want to explore local distilleries 🥃',
    'Lawn bowling this summer 🎱',
    'Looking for a croquet partner 🏑',
    'Horseback riding lessons 🐴',
    'Want to learn archery 🏹',
    'Fencing class starting soon 🤺',
    'Looking for a rowing partner 🚣',
    'Sailing lessons this summer ⛵',
    'Want to learn how to kite surf 🪁',
    'Paddleboarding this weekend 🏄‍♀️',
    'Looking for a snorkeling buddy 🤿',
    'Scuba diving certification course 🐠',
    'Want to explore local hot springs ♨️',
    'Stargazing trip planned 🔭',
    'Looking for a camping buddy ⛺',
  ];

  const purposes = ['friends', 'dating', 'chatting', 'networking'];
  const visibilities = ['public', 'public', 'public', 'public', 'friends', 'only_me'];
  const tags = [
    ['music', 'social'],
    ['books', 'reading'],
    ['coffee', 'food'],
    ['outdoor', 'hiking'],
    ['travel', 'exploring'],
    ['music', 'festival'],
    ['food', 'restaurants'],
    ['fitness', 'gym'],
    ['art', 'photography'],
    ['games', 'social'],
    ['sports', 'tennis'],
    ['learning', 'language'],
    ['movies', 'entertainment'],
    ['wellness', 'yoga'],
    ['pets', 'social'],
    ['art', 'culture'],
    ['food', 'cooking'],
    ['sports', 'beach'],
    ['books', 'social'],
    ['tech', 'learning'],
    ['food', 'wine'],
    ['music', 'karaoke'],
    ['fitness', 'running'],
    ['food', 'social'],
    ['sports', 'climbing'],
    ['games', 'social'],
    ['tech', 'media'],
    ['dance', 'social'],
    ['hobbies', 'plants'],
    ['food', 'baking'],
  ];

  const posts: Post[] = [];

  for (let i = 0; i < 99; i++) {
    const randomUserId = userIds[Math.floor(Math.random() * userIds.length)];
    const randomContent = contents[i % contents.length];
    const randomPurpose = purposes[Math.floor(Math.random() * purposes.length)];
    const randomVisibility = visibilities[Math.floor(Math.random() * visibilities.length)];
    const randomTags = tags[i % tags.length];
    const randomLikeCount = Math.floor(Math.random() * 100);
    const randomCommentCount = Math.floor(Math.random() * 20);
    const randomDaysAgo = Math.floor(Math.random() * 30);
    const createdAt = new Date();
    createdAt.setDate(createdAt.getDate() - randomDaysAgo);

    const post = postRepository.create({
      userId: randomUserId,
      content: randomContent,
      tags: randomTags,
      purpose: randomPurpose,
      visibility: randomVisibility,
      images: [],
      likeCount: randomLikeCount,
      commentCount: randomCommentCount,
      status: 'approved',
      isAnonymous: 0,
      createdAt: createdAt,
      updatedAt: createdAt,
    });

    posts.push(post);
  }

  await postRepository.save(posts);

  console.log(`✅ Successfully seeded ${posts.length} posts`);

  await AppDataSource.destroy();
}

seedPosts().catch((error) => {
  console.error('Error seeding posts:', error);
  process.exit(1);
});
