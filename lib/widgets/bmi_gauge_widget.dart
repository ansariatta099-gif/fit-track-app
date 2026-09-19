import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class BmiGaugeWidget extends StatelessWidget {
  final double bmi;

  const BmiGaugeWidget({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    // Range: 15 to 35
    final clampedBmi = bmi.clamp(15.0, 35.0);
    final indicatorFraction = (clampedBmi - 15.0) / (35.0 - 15.0);

    return Column(
      children: [
        // Bar container
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 10,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 18,
                          child: Container(color: AppColors.bmiUnderweight),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          flex: 32,
                          child: Container(color: AppColors.bmiNormal),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          flex: 25,
                          child: Container(color: AppColors.bmiOverweight),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          flex: 25,
                          child: Container(color: AppColors.bmiObese),
                        ),
                      ],
                    ),
                  ),
                ),
                // Indicator arrow
                Positioned(
                  left: (indicatorFraction * w - 6).clamp(0.0, w - 12.0),
                  top: -6,
                  child: Container(
                    width: 12,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 4,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        // Labels
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BmiLabel(title: 'Underweight', range: '< 18.5', color: AppColors.bmiUnderweight),
            _BmiLabel(title: 'Normal', range: '18.5-24.9', color: AppColors.bmiNormal),
            _BmiLabel(title: 'Overweight', range: '25-29.9', color: AppColors.bmiOverweight),
            _BmiLabel(title: 'Obese', range: '30+', color: AppColors.bmiObese),
          ],
        ),
      ],
    );
  }
}

class _BmiLabel extends StatelessWidget {
  final String title;
  final String range;
  final Color color;

  const _BmiLabel({required this.title, required this.range, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          range,
          style: const TextStyle(fontSize: 9, color: Colors.grey),
        ),
      ],
    );
  }
}
