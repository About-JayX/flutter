
import 'package:flutter_test/flutter_test.dart';
import 'package:mobisen_app/util/text_utils.dart';

void main() {
  group('text test', () {
    test('check text is null or empty', () {
      String str = '';
      bool result = TextUtils.isNullOrEmpty(str);
      expect(result, true);
    });
  });
}
