import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/widget/mixed_list/account_mixed_list_item.dart';
import 'package:mobisen_app/widget/mixed_list/mixed_list_view.dart';
import 'package:mobisen_app/widget/mixed_list/profile_mixed_list_item.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    return SafeArea(
      child: MixedListView(
        bottomNavPadding: true,
        onRefresh: () async {
          await accountProvider.updateAccountProfile();
        },
        data: [
          AccountMixedListItem(),
          ProfileMixedListItem(),
        ],
      ),
    );
  }
}
