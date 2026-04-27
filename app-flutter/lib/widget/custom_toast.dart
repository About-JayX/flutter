import 'dart:async';

import 'package:flutter/material.dart';

class CustomToast {
  static OverlayEntry? _currentEntry;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    required String message,
    int duration = 2000,
    IconData? icon,
    VoidCallback? onDismiss,
  }) {
    _dismiss();

    final overlay = Overlay.of(context);
    _currentEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        icon: icon ?? Icons.warning_amber_rounded,
        onDismiss: onDismiss,
      ),
    );

    overlay.insert(_currentEntry!);

    _timer = Timer(Duration(milliseconds: duration), () {
      _dismiss();
    });
  }

  static void _dismiss() {
    _timer?.cancel();
    _timer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onDismiss;

  const _ToastWidget({
    required this.message,
    required this.icon,
    this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.onDismiss?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xB380576B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
