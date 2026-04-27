import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/viewmodel/account_view_model.dart';

class ShowViewModel extends AccountViewModel {
  int showId;
  Show? show;

  ShowViewModel({required super.accountProvider, required this.showId});

  @override
  void initModel() {
    refresh();
  }

  void refresh() async {
    setLoading(true);
    try {
      show = await ApiService.instance.getShowDetail(accountProvider.account, showId);
    } catch (e) {}

    setLoading(false);
  }
}
