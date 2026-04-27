import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobisen_app/model/mockdata.dart';
import 'package:mobisen_app/model/data.dart';

void main() {
  group('unittest test', () {
    test('mockdata test', () {
      Data data1 = Data.fromJson(json.decode(JsonString.mockdata));
      expect(data1.url, 'http://www.mobisen.com');
    });
  });
}
