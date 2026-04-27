import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';

class EmptyErrorView extends StatelessWidget {
  final Function()? onTap;
  final String? emptyImageAsset;
  final String? emptyMsg;
  final IconData? emptyIcon;

  const EmptyErrorView(
      {super.key,
      this.onTap,
      this.emptyImageAsset,
      this.emptyMsg,
      this.emptyIcon});

  @override
  Widget build(BuildContext context) {
    final imageAsset = emptyImageAsset ?? Assets.images.networkError.path
        // Assets.images.emptyPage.path
        ;
    final icon = emptyIcon ?? Icons.refresh;
    final msg = emptyMsg ?? S.of(context).network_error;
    return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
                  onTap: onTap,
                  child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(imageAsset,
                              fit: BoxFit.contain,
                              width: min(200, constraints.maxWidth)),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon),
                              const SizedBox(width: 8),
                              Flexible(
                                  child: Text(
                                msg,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ))
                            ],
                          )
                        ],
                      )),
                )));
  }
}
