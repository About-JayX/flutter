import 'package:flutter/material.dart';
import 'package:mobisen_app/app_router.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/widget/image_loader.dart';

class ShowItem extends StatelessWidget {
  final Show show;

  const ShowItem({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.show,
            arguments: CommonArgs(showId: show.showId));
      },
      child:
          // Container(
          //   color: Colors.green.withOpacity(0.5),
          //   child:
          Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ImageLoader.cover(url: show.coverUrl),
          ),
          Container(
            // color: Colors.red,
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              "${show.title}\n\n",
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
