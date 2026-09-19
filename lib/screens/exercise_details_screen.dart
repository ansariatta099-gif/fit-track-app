import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/workout_models.dart';
import '../providers/workout_provider.dart';
import '../widgets/neon_card.dart';
import '../widgets/custom_button.dart';
import 'workout_tracking_screen.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailsScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 190,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.neonGreen.withValues(alpha: 0.08),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.darkCardSecondary,
                                  border: Border.all(color: AppColors.neonGreen, width: 2),
                                ),
                                child: const Center(
                                  child: Icon(Icons.fitness_center_rounded, color: AppColors.neonGreen, size: 36),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                exercise.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: primaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _SpecRow(
                      icon: Icons.accessibility_new_rounded,
                      title: 'Muscle Group',
                      value: exercise.muscleGroup,
                    ),
                    const SizedBox(height: 12),
                    _SpecRow(
                      icon: Icons.fitness_center_rounded,
                      title: 'Equipment',
                      value: exercise.equipment,
                    ),
                    const SizedBox(height: 12),
                    _SpecRow(
                      icon: Icons.bolt_rounded,
                      title: 'Difficulty',
                      value: exercise.difficulty,
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    NeonCard(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        exercise.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: secondaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: CustomButton(
                text: 'Start Workout',
                onPressed: () {
                  context.read<WorkoutProvider>().setCurrentExercise(exercise);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutTrackingScreen(exercise: exercise),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SpecRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return NeonCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neonGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textWhite : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
