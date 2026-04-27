import { Module, forwardRef } from '@nestjs/common';
import { QueueModule } from '../queue/queue.module';
import { MonitoringController } from './monitoring.controller';
import { MonitoringUiController } from './monitoring-ui.controller'; // 新增
import { ActivitiesModule } from '../activities/activities.module';
import { QueueMonitoringService } from './queue-monitoring.service';

@Module({
  imports: [
    QueueModule,
    forwardRef(() => ActivitiesModule), // 使用 forwardRef 避免循环依赖
  ],
  controllers: [MonitoringController, MonitoringUiController],
  providers: [QueueMonitoringService],
  exports: [QueueMonitoringService],
})
export class MonitoringModule {}