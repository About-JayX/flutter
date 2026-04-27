import 'package:flutter/material.dart';
import 'package:mobisen_app/util/theme_helper.dart';

class DailyLifeIcon extends StatelessWidget {
  final double size;
  final Color color;

  const DailyLifeIcon(
      {super.key, this.size = 24, this.color = ThemeHelper.primaryColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DailyLifePainter(color),
    );
  }
}

class _DailyLifePainter extends CustomPainter {
  final Color color;

  _DailyLifePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.15, size.width * 0.5,
          size.height * 0.45),
      Radius.circular(size.width * 0.05),
    );
    canvas.drawRRect(rect, paint);

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.375),
      size.width * 0.08,
      paint,
    );

    final path = Path()
      ..moveTo(size.width * 0.55, size.height * 0.55)
      ..lineTo(size.width * 0.95, size.height * 0.25)
      ..lineTo(size.width * 0.85, size.height * 0.85)
      ..close();
    canvas.drawPath(path, paint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GuitarIcon extends StatelessWidget {
  final double size;
  final Color color;

  const GuitarIcon(
      {super.key, this.size = 24, this.color = ThemeHelper.primaryColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GuitarPainter(color),
    );
  }
}

class _GuitarPainter extends CustomPainter {
  final Color color;

  _GuitarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final bodyPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.6),
        width: size.width * 0.55,
        height: size.height * 0.45,
      ));
    canvas.drawPath(bodyPath, paint);

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.15),
      Offset(size.width * 0.5, size.height * 0.4),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.42, size.height * 0.25),
      Offset(size.width * 0.42, size.height * 0.55),
      paint..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(size.width * 0.58, size.height * 0.25),
      Offset(size.width * 0.58, size.height * 0.55),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CasualChatIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CasualChatIcon(
      {super.key, this.size = 24, this.color = ThemeHelper.primaryColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CasualChatPainter(color),
    );
  }
}

class _CasualChatPainter extends CustomPainter {
  final Color color;

  _CasualChatPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.55)
      ..lineTo(size.width * 0.35, size.height * 0.55)
      ..lineTo(size.width * 0.45, size.height * 0.85)
      ..lineTo(size.width * 0.55, size.height * 0.55)
      ..lineTo(size.width * 0.75, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.55,
          size.width * 0.85, size.height * 0.45)
      ..lineTo(size.width * 0.85, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.15,
          size.width * 0.75, size.height * 0.15)
      ..lineTo(size.width * 0.25, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.15,
          size.width * 0.15, size.height * 0.25)
      ..lineTo(size.width * 0.15, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.55,
          size.width * 0.25, size.height * 0.55)
      ..close();
    canvas.drawPath(path, paint);

    final bubblePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.35),
        size.width * 0.12, bubblePaint);
    canvas.drawLine(
      Offset(size.width * 0.72, size.height * 0.42),
      Offset(size.width * 0.78, size.height * 0.5),
      bubblePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TwoPeopleIcon extends StatelessWidget {
  final double size;
  final Color color;

  const TwoPeopleIcon(
      {super.key, this.size = 24, this.color = ThemeHelper.primaryColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TwoPeoplePainter(color),
    );
  }
}

class _TwoPeoplePainter extends CustomPainter {
  final Color color;

  _TwoPeoplePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(
        Offset(size.width * 0.35, size.height * 0.3), size.width * 0.12, paint);
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(size.width * 0.35, size.height * 0.75),
          width: size.width * 0.35,
          height: size.height * 0.35),
      3.14,
      3.14,
      false,
      paint,
    );

    canvas.drawCircle(
        Offset(size.width * 0.7, size.height * 0.35), size.width * 0.1, paint);
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(size.width * 0.7, size.height * 0.78),
          width: size.width * 0.28,
          height: size.height * 0.28),
      3.14,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HandshakeIcon extends StatelessWidget {
  final double size;
  final Color color;

  const HandshakeIcon(
      {super.key, this.size = 24, this.color = ThemeHelper.primaryColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HandshakePainter(color),
    );
  }
}

class _HandshakePainter extends CustomPainter {
  final Color color;

  _HandshakePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.25,
          size.width * 0.5, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.25,
          size.width * 0.8, size.height * 0.4)
      ..lineTo(size.width * 0.75, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.6, size.height * 0.75,
          size.width * 0.5, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.75,
          size.width * 0.25, size.height * 0.6)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WorkStressIcon extends StatelessWidget {
  final double size;
  final Color color;

  const WorkStressIcon(
      {super.key, this.size = 24, this.color = ThemeHelper.primaryColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _WorkStressPainter(color),
    );
  }
}

class _WorkStressPainter extends CustomPainter {
  final Color color;

  _WorkStressPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.15, size.height * 0.25, size.width * 0.5,
          size.height * 0.35),
      Radius.circular(size.width * 0.03),
    );
    canvas.drawRRect(rect, paint);

    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.35),
      Offset(size.width * 0.5, size.height * 0.35),
      paint..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.45),
      Offset(size.width * 0.45, size.height * 0.45),
      paint,
    );

    final lightning = Path()
      ..moveTo(size.width * 0.72, size.height * 0.2)
      ..lineTo(size.width * 0.62, size.height * 0.45)
      ..lineTo(size.width * 0.72, size.height * 0.45)
      ..lineTo(size.width * 0.62, size.height * 0.75)
      ..lineTo(size.width * 0.82, size.height * 0.4)
      ..lineTo(size.width * 0.72, size.height * 0.4)
      ..close();
    canvas.drawPath(lightning, paint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LonelinessIcon extends StatelessWidget {
  final double size;
  final Color color;

  const LonelinessIcon(
      {super.key, this.size = 24, this.color = ThemeHelper.primaryColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LonelinessPainter(color),
    );
  }
}

class _LonelinessPainter extends CustomPainter {
  final Color color;

  _LonelinessPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // umbrella handle
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.55),
      paint,
    );

    // umbrella canopy
    final canopyPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.05,
          size.width * 0.8, size.height * 0.35);
    canvas.drawPath(canopyPath, paint);

    // person body (sitting)
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.68),
      size.width * 0.1,
      paint,
    );

    final bodyPath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.78)
      ..lineTo(size.width * 0.5, size.height * 0.75)
      ..lineTo(size.width * 0.65, size.height * 0.78)
      ..lineTo(size.width * 0.62, size.height * 0.95)
      ..lineTo(size.width * 0.38, size.height * 0.95)
      ..close();
    canvas.drawPath(bodyPath, paint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
