import 'package:flutter/material.dart';

class FixedAspectRatio extends StatelessWidget {
  final double aspectRatio;
  final Widget child;

  const FixedAspectRatio(
      {super.key, required this.aspectRatio, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final actualAspectRatio = maxWidth / maxHeight;
        double width, height;
        if (actualAspectRatio > aspectRatio) {
          height = maxHeight;
          width = height * aspectRatio;
        } else {
          width = maxWidth;
          height = width / aspectRatio;
        }
        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: child,
          ),
        );
      },
    );
  }
}
