import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/net/model/homepage.dart';
import 'package:mobisen_app/viewmodel/account_view_model.dart';

class HomeViewModel extends AccountViewModel {
  Homepage? homepage;
  // String? currentCarouselImageUrl;
  double headShadowOpacity = 0.0;

  HomeViewModel({required super.accountProvider});

  @override
  void initModel() async {
    await refresh();
    await accountProvider.updateAccountProfile();
  }

  void changeHeadShadowOpacity({
    required double opacity,
  }) async {
    headShadowOpacity = opacity;
    notifyListeners();
  }
  // void changeCarouselImageUrl({
  //   required String url,
  // }) async {
  //   currentCarouselImageUrl = url;
  //   notifyListeners();
  // }

  Future<void> refresh() async {
    setLoading(true, error: false);
    bool success = false;
    for (var i = 0; i < 3 && !success; i++) {
      success = await _fetchHomepage();
    }
    setLoading(false, error: !success);
  }

  Future<bool> _fetchHomepage() async {
    try {
      homepage = await ApiService.instance.getHomepage(accountProvider.account);
      return true;
    } catch (_) {
      return false;
    }
  }
}
