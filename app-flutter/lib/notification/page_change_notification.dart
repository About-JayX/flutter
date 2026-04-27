import 'package:flutter/material.dart';

class PageChangeNotification extends Notification {
  final dynamic pageItem;

  PageChangeNotification(this.pageItem);
}
