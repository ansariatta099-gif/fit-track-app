import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BMIResult {
  final double bmi;
  final String category;
  final Color categoryColor;
  final String healthyRange;
  final double minHealthyWeight;
  final double maxHealthyWeight;

  BMIResult({
    required this.bmi,
    required this.category,
    required this.categoryColor,
    required this.healthyRange,
    required this.minHealthyWeight,
    required this.maxHealthyWeight,
  });
}

class FitnessCalculators {
  static BMIResult calculateBMI(double heightCm, double weightKg) {
    if (heightCm <= 0 || weightKg <= 0) {
      return BMIResult(
        bmi: 0,
        category: 'Invalid',
        categoryColor: Colors.grey,
        healthyRange: '18.5 - 24.9',
        minHealthyWeight: 50,
        maxHealthyWeight: 75,
      );
    }
    final heightM = heightCm / 100.0;
    final bmi = weightKg / (heightM * heightM);

    String category;
    Color color;
    if (bmi < 18.5) {
      category = 'Underweight';
      color = AppColors.bmiUnderweight;
    } else if (bmi <= 24.9) {
      category = 'Normal';
      color = AppColors.bmiNormal;
    } else if (bmi <= 29.9) {
      category = 'Overweight';
      color = AppColors.bmiOverweight;
    } else {
      category = 'Obese';
      color = AppColors.bmiObese;
    }

    final minW = 18.5 * heightM * heightM;
    final maxW = 24.9 * heightM * heightM;

    return BMIResult(
      bmi: double.parse(bmi.toStringAsFixed(1)),
      category: category,
      categoryColor: color,
      healthyRange: '18.5 - 24.9',
      minHealthyWeight: double.parse(minW.toStringAsFixed(1)),
      maxHealthyWeight: double.parse(maxW.toStringAsFixed(1)),
    );
  }

  static int calculateBMR({
    required int age,
    required String gender,
    required double heightCm,
    required double weightKg,
  }) {
    // Mifflin-St Jeor Equation
    double bmr;
    if (gender.toLowerCase() == 'male') {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
    return bmr.round();
  }

  static int calculateDailyCalorieGoal({
    required int age,
    required String gender,
    required double heightCm,
    required double weightKg,
    required String activityLevel,
    required String goal,
  }) {
    final bmr = calculateBMR(
      age: age,
      gender: gender,
      heightCm: heightCm,
      weightKg: weightKg,
    );

    double multiplier = 1.2;
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        multiplier = 1.2;
        break;
      case 'light':
        multiplier = 1.375;
        break;
      case 'moderate':
        multiplier = 1.55;
        break;
      case 'very active':
        multiplier = 1.725;
        break;
      case 'extra active':
        multiplier = 1.9;
        break;
      default:
        multiplier = 1.55;
    }

    final tdee = bmr * multiplier;

    double goalAdjustment = 0;
    if (goal.toLowerCase().contains('lose')) {
      goalAdjustment = -500;
    } else if (goal.toLowerCase().contains('gain') || goal.toLowerCase().contains('muscle')) {
      goalAdjustment = 300;
    }

    return (tdee + goalAdjustment).round();
  }
}
