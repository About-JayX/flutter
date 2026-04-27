import 'package:in_app_review/in_app_review.dart';
import 'package:mobisen_app/util/track_helper.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/constants.dart';

class InAppReviewHelper {
  static final InAppReview inAppReview = InAppReview.instance;
  static Future<void> toReview() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
      // try {
      TrackHelper.instance.track(
        event: TrackEvents.inAppReview,
        action: TrackValues.show,
      );
      // } catch (e) {
      //   LogE("TrackHelper - inAppRevie：\n$e");
      // }
      LogI("inAppReview.isAvailable()：\ntrue");
    }
  }
}
