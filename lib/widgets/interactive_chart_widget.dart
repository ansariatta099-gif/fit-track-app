import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants/app_colors.dart';
import '../providers/progress_provider.dart';

class InteractiveChartWidget extends StatelessWidget {
  final List<ProgressPoint> points;
  final String unit;

  const InteractiveChartWidget({
    super.key,
    required this.points,
    this.unit = 'kg',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? AppColors.textMuted : AppColors.lightTextSecondary;

    if (points.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('No data available')),
      );
    }

    final minY = points.map((p) => p.value).reduce((a, b) => a < b ? a : b) * 0.95;
    final maxY = points.map((p) => p.value).reduce((a, b) => a > b ? a : b) * 1.05;

    return SizedBox(
      height: 190,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) / 4 > 0 ? (maxY - minY) / 4 : 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < points.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        points[index].label,
                        style: TextStyle(
                          color: subColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                points.length,
                (i) => FlSpot(i.toDouble(), points[i].value),
              ),
              isCurved: true,
              curveSmoothness: 0.35,
              color: AppColors.neonGreen,
              barWidth: 3.2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4.5,
                    color: AppColors.neonGreen,
                    strokeWidth: 2,
                    strokeColor: isDark ? AppColors.darkBg : Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.neonGreen.withValues(alpha: 0.3),
                    AppColors.neonGreen.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)} $unit',
                    const TextStyle(
                      color: AppColors.darkBg,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
