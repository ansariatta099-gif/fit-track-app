import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class DumbbellLogoWidget extends StatelessWidget {
  final double size;
  final Color color;

  const DumbbellLogoWidget({
    super.key,
    this.size = 64,
    this.color = AppColors.neonGreen,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DumbbellLogoPainter(color),
      ),
    );
  }
}

class _DumbbellLogoPainter extends CustomPainter {
  final Color color;
  _DumbbellLogoPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final w = size.width;
    final h = size.height;

    // Draw 'F' shaped stylized dumbbell
    final leftPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.05, h * 0.2, w * 0.12, h * 0.6),
      Radius.circular(w * 0.04),
    );
    final leftInner = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.20, h * 0.3, w * 0.08, h * 0.4),
      Radius.circular(w * 0.03),
    );
    final centerBar = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.28, h * 0.44, w * 0.44, h * 0.12),
      Radius.circular(w * 0.02),
    );
    final rightInner = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.72, h * 0.3, w * 0.08, h * 0.4),
      Radius.circular(w * 0.03),
    );
    final rightPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.83, h * 0.2, w * 0.12, h * 0.6),
      Radius.circular(w * 0.04),
    );

    final topBar = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.20, h * 0.12, w * 0.55, h * 0.10),
      Radius.circular(w * 0.03),
    );

    canvas.drawRRect(leftPlate, glowPaint);
    canvas.drawRRect(leftPlate, paint);
    canvas.drawRRect(leftInner, paint);
    canvas.drawRRect(centerBar, glowPaint);
    canvas.drawRRect(centerBar, paint);
    canvas.drawRRect(rightInner, paint);
    canvas.drawRRect(rightPlate, glowPaint);
    canvas.drawRRect(rightPlate, paint);
    canvas.drawRRect(topBar, glowPaint);
    canvas.drawRRect(topBar, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NeonRunnerArtwork extends StatelessWidget {
  final double width;
  final double height;

  const NeonRunnerArtwork({
    super.key,
    this.width = 280,
    this.height = 320,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _NeonRunnerPainter(),
      ),
    );
  }
}

class _NeonRunnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = AppColors.neonGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..color = AppColors.neonGreen.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final w = size.width;
    final h = size.height;

    final bodyPath = Path();

    // Head
    final headCenter = Offset(w * 0.65, h * 0.18);
    canvas.drawCircle(headCenter, w * 0.06, glowPaint);
    canvas.drawCircle(headCenter, w * 0.06, strokePaint);

    // Torso forward lean
    bodyPath.moveTo(w * 0.62, h * 0.24);
    bodyPath.lineTo(w * 0.45, h * 0.48);

    // Back leg
    bodyPath.moveTo(w * 0.45, h * 0.48);
    bodyPath.lineTo(w * 0.28, h * 0.62);
    bodyPath.lineTo(w * 0.14, h * 0.82);

    // Front leg
    bodyPath.moveTo(w * 0.45, h * 0.48);
    bodyPath.lineTo(w * 0.58, h * 0.56);
    bodyPath.lineTo(w * 0.50, h * 0.78);

    // Left arm
    bodyPath.moveTo(w * 0.58, h * 0.28);
    bodyPath.lineTo(w * 0.40, h * 0.32);
    bodyPath.lineTo(w * 0.25, h * 0.25);

    // Right arm
    bodyPath.moveTo(w * 0.58, h * 0.28);
    bodyPath.lineTo(w * 0.72, h * 0.34);
    bodyPath.lineTo(w * 0.80, h * 0.22);

    // Motion lines
    final trailPath = Path();
    trailPath.moveTo(w * 0.08, h * 0.88);
    trailPath.lineTo(w * 0.85, h * 0.88);

    trailPath.moveTo(w * 0.18, h * 0.92);
    trailPath.lineTo(w * 0.65, h * 0.92);

    canvas.drawPath(bodyPath, glowPaint);
    canvas.drawPath(bodyPath, strokePaint);
    canvas.drawPath(trailPath, glowPaint);
    canvas.drawPath(trailPath, strokePaint);

    final dotPaint = Paint()..color = AppColors.neonGreen.withValues(alpha: 0.8);
    final dots = [
      Offset(w * 0.20, h * 0.15),
      Offset(w * 0.82, h * 0.12),
      Offset(w * 0.88, h * 0.45),
      Offset(w * 0.12, h * 0.42),
      Offset(w * 0.35, h * 0.75),
      Offset(w * 0.75, h * 0.70),
    ];
    for (var dot in dots) {
      canvas.drawCircle(dot, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NeonLifterArtwork extends StatelessWidget {
  final double width;
  final double height;

  const NeonLifterArtwork({
    super.key,
    this.width = 280,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _NeonLifterPainter(),
      ),
    );
  }
}

class _NeonLifterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = AppColors.neonGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..color = AppColors.neonGreen.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final w = size.width;
    final h = size.height;

    final bodyPath = Path();

    // Barbell overhead
    final barPath = Path();
    barPath.moveTo(w * 0.08, h * 0.25);
    barPath.lineTo(w * 0.92, h * 0.25);

    final p1 = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.06, h * 0.12, w * 0.06, h * 0.26), const Radius.circular(4));
    final p2 = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.88, h * 0.12, w * 0.06, h * 0.26), const Radius.circular(4));

    // Lifter Head
    final headCenter = Offset(w * 0.50, h * 0.35);
    canvas.drawCircle(headCenter, w * 0.05, glowPaint);
    canvas.drawCircle(headCenter, w * 0.05, strokePaint);

    // Arms holding barbell
    bodyPath.moveTo(w * 0.26, h * 0.25);
    bodyPath.lineTo(w * 0.38, h * 0.38);
    bodyPath.lineTo(w * 0.48, h * 0.44);

    bodyPath.moveTo(w * 0.74, h * 0.25);
    bodyPath.lineTo(w * 0.62, h * 0.38);
    bodyPath.lineTo(w * 0.52, h * 0.44);

    // Torso
    bodyPath.moveTo(w * 0.50, h * 0.44);
    bodyPath.lineTo(w * 0.50, h * 0.60);

    // Legs
    bodyPath.moveTo(w * 0.50, h * 0.60);
    bodyPath.lineTo(w * 0.36, h * 0.72);
    bodyPath.lineTo(w * 0.32, h * 0.88);

    bodyPath.moveTo(w * 0.50, h * 0.60);
    bodyPath.lineTo(w * 0.64, h * 0.72);
    bodyPath.lineTo(w * 0.68, h * 0.88);

    canvas.drawPath(barPath, glowPaint);
    canvas.drawPath(barPath, strokePaint);
    canvas.drawRRect(p1, glowPaint);
    canvas.drawRRect(p1, strokePaint);
    canvas.drawRRect(p2, glowPaint);
    canvas.drawRRect(p2, strokePaint);

    canvas.drawPath(bodyPath, glowPaint);
    canvas.drawPath(bodyPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
