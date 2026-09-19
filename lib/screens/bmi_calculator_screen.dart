import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/fitness_calculators.dart';
import '../providers/profile_provider.dart';
import '../widgets/neon_card.dart';
import '../widgets/bmi_gauge_widget.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  late double _heightCm;
  late double _weightKg;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _heightCm = profile.heightCm;
    _weightKg = profile.weightKg;
  }

  @override
  Widget build(BuildContext context) {
    final bmiResult = FitnessCalculators.calculateBMI(_heightCm, _weightKg);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeonCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Height', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
                        Text('${_heightCm.toInt()} cm', style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Slider(
                      value: _heightCm,
                      min: 100,
                      max: 220,
                      activeColor: AppColors.neonGreen,
                      inactiveColor: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                      onChanged: (val) {
                        setState(() => _heightCm = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              NeonCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Weight', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
                        Text('${_weightKg.toStringAsFixed(1)} kg', style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Slider(
                      value: _weightKg,
                      min: 30,
                      max: 180,
                      activeColor: AppColors.neonGreen,
                      inactiveColor: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                      onChanged: (val) {
                        setState(() => _weightKg = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              NeonCard(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      '${bmiResult.bmi}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: bmiResult.categoryColor,
                        letterSpacing: -1.0,
                      ),
                    ),
                    Text(
                      bmiResult.category,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: bmiResult.categoryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    BmiGaugeWidget(bmi: bmiResult.bmi),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              NeonCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Healthy BMI Range',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '18.5 - 24.9',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ideal weight: ${bmiResult.minHealthyWeight} kg - ${bmiResult.maxHealthyWeight} kg',
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
