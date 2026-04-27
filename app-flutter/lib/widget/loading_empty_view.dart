import 'package:flutter/material.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';
import 'package:mobisen_app/widget/empty_view.dart';
import 'package:mobisen_app/widget/loading.dart';

class LoadingEmptyView extends StatelessWidget {
  final bool loading;
  final bool error;
  final Function()? onRefresh;

  const LoadingEmptyView({
    super.key,
    required this.loading,
    this.error = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: ((context, constraints) => ListView(
              children: [
                SizedBox(
                    height: constraints.maxHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (loading
                            ? const Loading()
                            : (error
                                ? EmptyErrorView(
                                    onTap: onRefresh,
                                  )
                                : EmptyErrorView(
                                    onTap: onRefresh,
                                    emptyImageAsset:
                                        Assets.images.emptyPage.path,
                                    emptyMsg: S.current.empty_page,
                                  )))
                        // EmptyErrorView(
                        //     onTap: onRefresh,
                        //     emptyImageAsset:
                        //         Assets.images.emptyPlaylist.path,
                        //     emptyMsg: S.current.empty_list_hint,
                        //   )))
                      ],
                    ))
              ],
            )));
  }
}
