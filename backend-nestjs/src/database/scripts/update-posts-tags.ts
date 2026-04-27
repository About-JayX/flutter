import { DataSource } from 'typeorm';
import * as dotenv from 'dotenv';
import * as fs from 'fs';
import * as path from 'path';
import { Post } from '../../modules/feed/entities/post.entity';

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
  entities: [Post],
  logging: false,
});

async function updatePostsTags() {
  await AppDataSource.initialize();

  const postRepository = AppDataSource.getRepository(Post);

  const topics = [
    { emoji: '🥾', text: 'Need to get outside this weekend #' },
    { emoji: '🍳', text: 'Want to try a new restaurant #' },
    { emoji: '🎸', text: 'Learning guitar, need motivation #' },
    { emoji: '🎬', text: 'Looking for a movie buddy #' },
    { emoji: '📚', text: 'In a reading slump, need recs' },
    { emoji: '☕', text: 'Need caffeine to function' },
    { emoji: '🍕', text: 'Ordering takeout = self-care' },
    { emoji: '🛋️', text: 'Doing nothing, zero guilt' },
    { emoji: '🌙', text: 'Up too late for no reason' },
    { emoji: '📺', text: "Binge-watching something I won't admit" },
    { emoji: '🎵', text: 'Need a playlist and someone to send it to' },
    { emoji: '🍳', text: 'Attempting to cook, probably failing' },
  ];

  const posts = await postRepository.find();

  console.log(`Found ${posts.length} posts to update`);

  for (const post of posts) {
    const randomTopic = topics[Math.floor(Math.random() * topics.length)];
    
    post.tags = [randomTopic];
    post.purpose = randomTopic.text;
    
    await postRepository.save(post);
    
    console.log(`Updated post ${post.id} with tag: ${randomTopic.emoji} ${randomTopic.text}`);
  }

  console.log(`✅ Successfully updated ${posts.length} posts with new tags format`);

  await AppDataSource.destroy();
}

updatePostsTags().catch((error) => {
  console.error('Error updating posts tags:', error);
  process.exit(1);
});
