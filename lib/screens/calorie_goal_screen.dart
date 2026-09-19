import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/fitness_calculators.dart';
import '../providers/profile_provider.dart';
import '../widgets/neon_card.dart';
import '../widgets/custom_button.dart';

class CalorieGoalScreen extends StatefulWidget {
  const CalorieGoalScreen({super.key});

  @override
  State<CalorieGoalScreen> createState() => _CalorieGoalScreenState();
}

class _CalorieGoalScreenState extends State<CalorieGoalScreen> {
  late int _age;
  late String _gender;
  late double _heightCm;
  late double _weightKg;
  String _activityLevel = 'Moderate';
  String _goal = 'Lose Weight';

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _age = profile.age;
    _gender = profile.gender;
    _heightCm = profile.heightCm;
    _weightKg = profile.weightKg;
  }

  @override
  Widget build(BuildContext context) {
    final calorieGoal = FitnessCalculators.calculateDailyCalorieGoal(
      age: _age,
      gender: _gender,
      heightCm: _heightCm,
      weightKg: _weightKg,
      activityLevel: _activityLevel,
      goal: _goal,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Goal Calculator'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeonCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Activity Level', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _activityLevel,
                        dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                        style: TextStyle(color: primaryText, fontWeight: FontWeight.bold, fontSize: 15),
                        items: ['Sedentary', 'Light', 'Moderate', 'Very Active', 'Extra Active']
                            .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _activityLevel = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              NeonCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Goal', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _goal,
                        dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                        style: TextStyle(color: primaryText, fontWeight: FontWeight.bold, fontSize: 15),
                        items: ['Lose Weight', 'Maintain Weight', 'Muscle Gain']
                            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _goal = val);
                        },
                      ),
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
                        Text('Height', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
                        Text('${_heightCm.toInt()} cm', style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Slider(
                      value: _heightCm,
                      min: 100,
                      max: 220,
                      activeColor: AppColors.neonGreen,
                      onChanged: (val) => setState(() => _heightCm = val),
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
                      onChanged: (val) => setState(() => _weightKg = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              NeonCard(
                hasNeonBorder: true,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Calorie Goal',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: secondaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          calorieGoal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppColors.neonGreen,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'kcal/day',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              CustomButton(
                text: 'Set as Daily Calorie Goal',
                onPressed: () {
                  final profileProvider = context.read<ProfileProvider>();
                  profileProvider.updateProfile(
                    profileProvider.profile.copyWith(dailyCalorieGoal: calorieGoal),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Daily Calorie Goal updated!'),
                      backgroundColor: AppColors.neonGreenDark,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
