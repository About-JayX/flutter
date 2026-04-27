import 'package:flutter/material.dart';

class CardForMemberPro extends StatelessWidget {
  const CardForMemberPro({
    super.key,
    required this.imageChild,
    required this.title,
    required this.des,
    required this.goChild,
    this.left,
    this.right,
    this.titleColor,
    this.desColor,
    this.desSize,
    this.bgColor,
    this.gradientColor,
  });

  final Widget imageChild;
  final String title;
  final String des;
  final Widget goChild;
  final double? left;
  final double? right;
  final Color? titleColor;
  final Color? desColor;
  final double? desSize;
  final Color? bgColor;
  final Gradient? gradientColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // margin: const EdgeInsets.only(left: 9.58),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: gradientColor,
            borderRadius: BorderRadius.circular(8),
            color: bgColor ?? Theme.of(context).primaryColor,
          ),
          // height: 72,
          child: Padding(
            padding: EdgeInsets.only(
                left: left != null ? left! : 8, //24
                right: 18.67, //right != null ? right! : 22
                top: 13.99,
                bottom: 14.92), // , top: 13, bottom: 15 vertical: 10
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        imageChild,
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 9.23),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 23,
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: titleColor ??
                                              const Color.fromRGBO(
                                                  235, 71, 183, 1),
                                          fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2.02,
                                  ),
                                  SizedBox(
                                    height: 18.08,
                                    child: Text(des,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: desColor ??
                                              const Color.fromRGBO(
                                                  255, 107, 208, 0.69),
                                          fontSize: desSize ?? 13,
                                        )),
                                  ),
                                ],
                              )),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: goChild,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
