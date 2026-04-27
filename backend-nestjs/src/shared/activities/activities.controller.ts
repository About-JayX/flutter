import {  
  Controller, 
  Post, 
  Get, 
  Delete, 
  Body, 
  Param, 
  UsePipes, 
  ValidationPipe, 
  ParseUUIDPipe,
  Logger,
} from '@nestjs/common';
import { ActivitiesService } from './activities.service';
import { CreateActivityDto } from './dto/create-activity.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';
// import { Public } from '@/modules/auth/decorators/public.decorator';


@Controller('activities')
@UsePipes(new ValidationPipe({ transform: true }))
export class ActivitiesController {
  private readonly logger = new Logger(ActivitiesController.name);
  constructor(private readonly activitiesService: ActivitiesService) {}

  // @Public()
  @Post()
  async createActivity(
    @CurrentUser() user: any,//  ArgsAuthDto
    @Body() createActivityDto: CreateActivityDto,
  ){
    this.logger.log("user信息", user);
    this.logger.log("user信息uniqid: ", user.uniqid); 
    return this.activitiesService.createActivity(createActivityDto);
  }

  @Get(':id')
  async getActivity(@Param('id', ParseUUIDPipe) id: string){
    return this.activitiesService.getActivity(id);
  }

  @Delete(':id/cancel')
  async cancelActivity(@Param('id', ParseUUIDPipe) id: string){
    return this.activitiesService.cancelActivity(id);
  }

  // @Get('user/:userId')
  // async getUserActivities(@Param('userId') userId: string): Promise<Activity[]> {
  //   return this.activitiesService.getUserActivities(userId);
  // }
}