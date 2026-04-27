import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  bool _error = false;
  bool get error => _error;
  bool disposed = false;

  void setLoading(bool value, {bool error = false}) {
    _loading = value;
    _error = error;
    safeNotifyListeners();
  }

  void initModel() {}

  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  void safeNotifyListeners() {
    if (!disposed) {
      notifyListeners();
    }
  }
}
