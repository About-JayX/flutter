import 'package:flutter/material.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/generated/l10n.dart';

class CardForCoins extends StatelessWidget {
  const CardForCoins({
    super.key,
    required this.title,
    this.des,
    required this.goTips,
    this.activity = false,
    this.showPopular = false,
    this.save,
    this.index,
  });

  final String title;
  final String? des;
  final String goTips;
  final bool activity;
  final bool showPopular;
  final int? save;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Card(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   child:
            Container(
              margin: EdgeInsets.only(top: index == 0 ? 0 : 8.09),
              height: 67,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: activity ? 2 : 1,
                  color: activity
                      ? const Color.fromRGBO(235, 71, 183, 1)
                      : const Color.fromRGBO(255, 255, 255, .12),
                ),
                color: activity
                    ? const Color.fromRGBO(235, 71, 183, 0.16)
                    : const Color.fromRGBO(255, 255, 255, .02),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (des != null)
                          Text(
                            "$des",
                            style: const TextStyle(
                                // height: 20,
                                color: Color.fromRGBO(235, 71, 183, 1),
                                fontSize: 16),
                          ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        Text(
                          title,
                          style: const TextStyle(
                              // height: 23.44,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        goTips,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // ),
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showPopular)
                    Container(
                      height: 22.02,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(240, 32, 124, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          )),
                      padding: const EdgeInsets.only(left: 20, right: 6.9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            S.current.popular,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 3.71,
                          ),
                          Assets.images.fire.image(
                              fit: BoxFit.contain, width: 15.2, height: 15.2)
                        ],
                      ),
                    ),
                  if (save != null)
                    Container(
                      height: 22.02,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(250, 144, 5, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(showPopular ? 0 : 4),
                            bottomLeft: Radius.circular(showPopular ? 0 : 4),
                            topRight: const Radius.circular(5),
                            bottomRight: const Radius.circular(5),
                          )),
                      padding: EdgeInsets.only(
                          left: showPopular ? 8.09 : 14.98, right: 6.9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "+$save%",
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            width: 3.71,
                          ),
                          Assets.images.fire.image(
                              fit: BoxFit.contain, width: 15.2, height: 15.2)
                        ],
                      ),
                    ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
