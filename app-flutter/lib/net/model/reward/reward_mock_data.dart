abstract class JsonString {
  static final String rewardMockData = ''' {
      "sevenDayTask": {
        "days": 0,
        "isTodayChecked": false,
        "checkList":[
          {"income": 20},
          {"income": 30},
          {"income": 40},
          {"income": 50},
          {"income": 60},
          {"income": 70},
          {"income": 100}
        ]
      },
      "task":{
        "taskList":[
          {"id": 63, "recurrence": "daily", "income": 50, "title": "ad","language":{"title":"DDFADsdadafaSD"}, "type": 0, "extraInfo": {"url": "https://www.google.com"},"requiredTimes": 1, "status": "go"},
          {"id": 64, "recurrence": "daily", "income": 100, "title": "share", "type": 3, "extraInfo": {"url": "https://mobisen.onelink.me/2QAp/share"}, "requiredTimes": 1, "status": "go"},
          {"id": 65, "recurrence": "oneTime", "income": 80, "title": "Start Capture Frist", "type": 4, "extraInfo": "", "requiredTimes": 1, "status": "go"},
          {"id": 66, "recurrence": "oneTime", "income": 98, "title": "Unlock Frist Capture", "type": 5, "extraInfo": "", "requiredTimes": 1, "status": "go"}
        ]
      }
    }''';

  static final String rewardLoginMockData = ''' {
      "sevenDayTask": {
        "days": 2,
        "isTodayChecked": false,
        "checkList":[
          {"income": 20, "checked": true},
          {"income": 30, "checked": true},
          {"income": 40},
          {"income": 50},
          {"income": 60},
          {"income": 70},
          {"income": 100}
        ]
      },
      "task":{
        "taskList":[
          {"id": 1, "recurrence": "oneTime", "income": 20, "title": "Login App", "type": 1, "extraInfo": "", "requiredTimes": 1, "status": "claim"},
          {"id": 2, "recurrence": "daily", "income": 50, "title": "ad", "type": 2, "extraInfo": null,"requiredTimes": 1, "status": "go"},
          {"id": 3, "recurrence": "daily", "income": 100, "title": "share", "type": 3, "extraInfo": {"url": "https://mobisen.onelink.me/2QAp/share"}, "requiredTimes": 1, "status": "go"},
          {"id": 4, "recurrence": "oneTime", "income": 80, "title": "Start Capture Frist", "type": 4, "extraInfo": "", "requiredTimes": 1, "status": "go"},
          {"id": 5, "recurrence": "oneTime", "income": 98, "title": "Unlock Frist Capture", "type": 5, "extraInfo": "", "requiredTimes": 1, "status": "go"},
          {"id": 6, "recurrence": "oneTime", "income": 98, "title": "open Notification","language":{"title":"open Notification"}, "type": 6, "extraInfo": {"requiredTimes": 1}, "requiredTimes": 1, "status": "go"}
        ]
      }
    }''';
}
