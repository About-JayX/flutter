import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobisen_app/util/log.dart';

class LocalStorageUtil {
  static removeData(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.get(key) != null) {
        prefs.remove(key);
      }
    } catch (e) {
      LogE("LocalStorageUtil-removeData:\n$e");
    }
  }

  static setData(String key, dynamic value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value is String) {
        prefs.setString(key, value);
      } else if (value is int) {
        prefs.setInt(key, value);
      } else if (value is double) {
        prefs.setDouble(key, value);
      } else if (value is bool) {
        prefs.setBool(key, value);
      } else if (value is List<String>) {
        prefs.setStringList(key, value);
      } else {
        prefs.setString(key, jsonEncode(value));
      }
    } catch (e) {
      LogE("LocalStorageUtil-setData:\n$e");
    }
  }

  static Future<dynamic?> readData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic? result;
    try {
      if (prefs.containsKey(key)) {
        var value = prefs.get(key);
        if (value is String) {
          result = json.decode(value);
        } else if (value is int) {
          result = value;
        } else if (value is double) {
          result = value;
        } else if (value is bool) {
          result = value;
        } else if (value is List<String>) {
          result = value;
        }
      } else {
        result = null;
      }
    } catch (e) {
      LogE("LocalStorageUtil-readData:\n$e");
      result = null;
    }
    return result;
  }
}
