import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobisen_app/util/log.dart';

class RemoteMessageProvider extends ChangeNotifier {
  final List<RemoteMessage> _remoteMessageList = [];
  List<RemoteMessage> get remoteMessageList => _remoteMessageList;

  void addMessage(RemoteMessage message) async {
    _remoteMessageList.add(message);
    notifyListeners();
    LogD("RemoteMessage: \n${_remoteMessageList.length}");
    LogD(
        "RemoteMessage[0].: \n${_remoteMessageList.isNotEmpty ? _remoteMessageList[_remoteMessageList.length - 1].messageId : null}");
  }

  // void deleteMessage(String messageId) async {}

  bool isMessageExist(String? messageId) {
    for (var message in remoteMessageList) {
      if (message.messageId == messageId) {
        return true;
      }
    }
    return false;
  }
}
