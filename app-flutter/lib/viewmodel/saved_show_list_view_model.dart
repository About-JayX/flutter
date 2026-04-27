import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/viewmodel/account_view_model.dart';

class SavedShowListViewModel extends AccountViewModel {
  List<Show> get shows => accountProvider.savedShowsList;

  SavedShowListViewModel({required super.accountProvider});

  @override
  void initModel() async {
    await refresh();
  }

  Future<void> refresh() async {
    await accountProvider.refreshSavedShows();
  }
}
