import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/util/view_utils.dart';
import 'package:mobisen_app/viewmodel/account_view_model.dart';

class ShowButtonsViewModel extends AccountViewModel {
  final Show show;

  ShowButtonsViewModel({
    required super.accountProvider,
    required this.show,
  });

  @override
  void initModel() {}

  void saveShow() async {
    try {
      await accountProvider.addSavedShow(show);
    } catch (e) {
      ViewUtils.showToast(S.current.error_toast);
    }
  }

  void unsaveShow() async {
    try {
      await accountProvider.removeSavedShow(show);
    } catch (e) {
      ViewUtils.showToast(S.current.error_toast);
    }
  }
}
