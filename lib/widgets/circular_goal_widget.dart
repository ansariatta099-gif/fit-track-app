import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CircularGoalWidget extends StatelessWidget {
  final double percentage; // e.g. 0.70
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color? backgroundColor;

  const CircularGoalWidget({
    super.key,
    required this.percentage,
    this.size = 54,
    this.strokeWidth = 5.0,
    this.progressColor = AppColors.neonGreen,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? AppColors.darkBorder : Colors.grey.shade200);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              percentage: percentage,
              strokeWidth: strokeWidth,
              progressColor: progressColor,
              backgroundColor: bg,
            ),
          ),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              fontSize: size * 0.26,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textWhite : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;

  _CircularProgressPainter({
    required this.percentage,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * math.pi * percentage.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) =>
      oldDelegate.percentage != percentage || oldDelegate.progressColor != progressColor;
}
