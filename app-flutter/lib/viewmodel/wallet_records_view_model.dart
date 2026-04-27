import 'package:mobisen_app/net/api_service.dart';
import 'package:mobisen_app/net/model/wallet_record.dart';
import 'package:mobisen_app/viewmodel/account_view_model.dart';

class WalletRecordsViewModel extends AccountViewModel {
  final String endPoint;
  List<WalletRecord> records = [];

  WalletRecordsViewModel(
      {required super.accountProvider, required this.endPoint});

  @override
  void initModel() {
    refresh();
  }

  Future<void> refresh() async {
    setLoading(true, error: false);
    try {
      await _loadMore(refresh: true);
      setLoading(false, error: false);
    } catch (e) {
      setLoading(false, error: true);
    }
  }

  Future<void> loadMore() async {
    try {
      await _loadMore(refresh: false);
    } catch (e) {}
    safeNotifyListeners();
  }

  Future<void> _loadMore({bool refresh = false}) async {
    List<WalletRecord> list = (await ApiService.instance.getWalletRecords(
            endPoint,
            accountProvider.account,
            refresh ? 0 : records.length,
            20))
        .records;
    if (refresh) {
      records.clear();
    }
    records.addAll(list);
  }
}
