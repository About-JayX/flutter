import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { User } from './entities/user.entity';
import { UserNamesDB } from './entities/usernamesdb.entity';
import { UploadModule } from '@/modules/upload/upload.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      User,
      UserNamesDB,
    ]),
    UploadModule,
  ],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [
    UsersService,
  ],
})
export class UsersModule {}
