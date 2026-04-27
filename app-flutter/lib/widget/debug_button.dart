import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/routes/application.dart';

class DebugButton extends StatefulWidget {
  const DebugButton({super.key, required this.child});

  final Widget child;

  @override
  State<DebugButton> createState() => _DebugButtonState();
}

class _DebugButtonState extends State<DebugButton> {
  Offset _offset = const Offset(25, 50);

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) return widget.child;

    return Stack(
      children: [
        widget.child,
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _offset += details.delta;
              });
            },
            child: Material(
              color: const Color(0xFFFF4444),
              borderRadius: BorderRadius.circular(8),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Application.navigatorKey.currentState?.pushNamed(
                    RoutePaths.test,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: const Text(
                    'Test',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
