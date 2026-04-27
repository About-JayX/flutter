import 'package:event_bus/event_bus.dart';
import 'package:mobisen_app/enums/reward_task.dart';

/// init
EventBus eventBus = EventBus();

/// job
/// purchase
class UpdatePurchaseEvent {
  final bool isSuccess;
  UpdatePurchaseEvent(this.isSuccess);
}

/// switch Tab
class SwitchTabEvent {
  final int index;
  SwitchTabEvent(this.index);
}

/// refresh Reward
class UpdateRewardEvent {
  final RewardTaskJob job;
  final Map<String, dynamic>? args;
  UpdateRewardEvent(this.job, {this.args});
}
