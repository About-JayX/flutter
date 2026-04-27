import 'package:flutter_test/flutter_test.dart';
import 'package:mobisen_app/util/text_utils.dart';

void main() {
  group('api test', () {
    test('getReward', () {
      String str = '';
      bool result = TextUtils.isNullOrEmpty(str);
      expect(result, true);
    });
  });
}
