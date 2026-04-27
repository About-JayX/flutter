import * as dotenv from "dotenv";
import { join } from 'path';

const env = process.env.NODE_ENV || "dev";
const envPath = join(process.cwd(), `.env.${env}`);
dotenv.config({ path: envPath });

// console.log('Env path:', envPath);
// console.log('Process env:', process.env);

export default () => ({
  environment: env,
  database: {
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT as string, 10) || 3306,
    username: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    synchronize: process.env.DB_SYNCHRONIZE === 'true'
  },

});