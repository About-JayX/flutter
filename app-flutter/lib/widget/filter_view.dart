import 'dart:ui';
import 'package:flutter/material.dart';

class FilterView extends StatelessWidget {
  final double width;
  final double height;
  final double sigma;
  final double borderRadius;
  final Widget back;
  final Widget child;
  const FilterView({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.sigma = 7.0,
    this.borderRadius = 0.0,
    this.back = const SizedBox(),
    this.child = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    Widget current;
    current = ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(children: <Widget>[
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: back,
              ),
            ),
            child,

            // Positioned.fill(
            //   child: child: back,
            // ),
            // BackdropFilter(
            //     filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            //     child: child),
          ]),
        ));
    return current;
  }
}
