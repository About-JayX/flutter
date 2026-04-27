import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    hide();

    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withOpacity(.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 88.33),
              child: SizedBox(
                width: 46,
                height: 46,
                child: 
                  SpinKitCircle(
                    color: Color.fromRGBO(224, 119, 111, 1),
                    size: 46,
                  )
                  // CircularProgressIndicator(
                  //   valueColor: AlwaysStoppedAnimation<Color>(
                  //     Color.fromRGBO(224, 119, 111, 1),
                  //   ),
                  //   strokeWidth: 4.5,
                  // ),
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
