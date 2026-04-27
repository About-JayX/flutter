import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/viewmodel/base_view_model.dart';

class AccountViewModel extends BaseViewModel {
  AccountProvider accountProvider;

  AccountViewModel({required this.accountProvider});
}
