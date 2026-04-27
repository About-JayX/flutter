/// reward task enums.
enum RewardTask {
  checkIn('checkIn', 11111), // check in for 7 day.
  login('1', 1), // user first login.
  ad('2', 2), // ad.
  share('3', 3), // share app.
  watchEpisode('4', 4), // watch episode
  unlockEpisode('5', 5), // unlock episode
  openNotification('6', 6); // open notification

  final String value;
  final int num;
  const RewardTask(this.value, this.num);
}

/// enum values to strings.
const Map<RewardTask, String> rewardTaskStrings = {
  RewardTask.checkIn: 'checkIn',
  RewardTask.login: '1',
  RewardTask.ad: '2',
  RewardTask.share: '3',
  RewardTask.watchEpisode: '4',
  RewardTask.unlockEpisode: '5',
};

enum RewardTaskStatus {
  go,
  claim,
  none,
}

const Map<RewardTaskStatus, String> rewardTaskStatusStrings = {
  RewardTaskStatus.go: 'go',
  RewardTaskStatus.claim: 'claim',
};

enum RewardTaskJob { refresh, refreshLogin, watchEpisode, unlockEpisode }
