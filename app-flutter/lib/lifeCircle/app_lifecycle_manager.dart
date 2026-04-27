import 'dart:async';
import 'package:flutter/widgets.dart';

class AppLifecycleManager with WidgetsBindingObserver {
  final StreamController<AppLifecycleState> _lifecycleController =
      StreamController<AppLifecycleState>.broadcast();
  final List<StreamSubscription<AppLifecycleState>> _subscriptions = [];

  Stream<AppLifecycleState> get lifecycleStream => _lifecycleController.stream;

  AppLifecycleManager._();
  static final AppLifecycleManager _instance = AppLifecycleManager._();

  factory AppLifecycleManager() {
    return _instance;
  }

  void startListening() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stopListening() {
    WidgetsBinding.instance.removeObserver(this);
    cancelAllSubscriptions();
  }

  StreamSubscription<AppLifecycleState> subscribeToLifecycleStream(
      void Function(AppLifecycleState) onData) {
    final subscription = lifecycleStream.listen(onData);
    _subscriptions.add(subscription);
    return subscription;
  }

  void cancelAllSubscriptions() {
    if (!_lifecycleController.isClosed) {
      for (var subscription in _subscriptions) {
        subscription.cancel();
      }
      _subscriptions.clear();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_lifecycleController.isClosed) {
      _lifecycleController.add(state);
    }
  }

  void dispose() {
    cancelAllSubscriptions();
    if (!_lifecycleController.isClosed) {
      _lifecycleController.close();
    }
  }
}
