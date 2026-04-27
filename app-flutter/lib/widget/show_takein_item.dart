import 'package:flutter/material.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/view/home/home_tabs.dart';
import 'package:mobisen_app/notification/page_change_notification.dart';

class ShowTakeInItem extends StatelessWidget {
  const ShowTakeInItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PageChangeNotification(HomeTabs.home).dispatch(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Assets.images.bannerEnDreame.image().image,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Assets.images.plus
                    .image(fit: BoxFit.contain, width: 20, height: 20),
              )),
          Container(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              "",
              // textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 15.74 / 12,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      // )
    );
  }
}
