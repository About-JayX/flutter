import 'package:flutter/material.dart';

abstract class MixedListItem {
  // must return sliver
  List<Widget> buildWidgets(BuildContext context);
}
