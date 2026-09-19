import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/workout_provider.dart';
import '../models/workout_models.dart';
import '../widgets/neon_card.dart';
import 'exercise_details_screen.dart';

class ExerciseListScreen extends StatelessWidget {
  final WorkoutCategory category;

  const ExerciseListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final exercises = context.watch<WorkoutProvider>().getExercisesByCategory(category.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Text(
              category.description,
              style: TextStyle(
                fontSize: 13,
                color: secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            ...exercises.map((exercise) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NeonCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    context.read<WorkoutProvider>().setCurrentExercise(exercise);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExerciseDetailsScreen(exercise: exercise),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardSecondary : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(Icons.fitness_center_rounded, color: AppColors.neonGreen, size: 22),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: primaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${exercise.difficulty} • ${exercise.defaultSets} Sets • ${exercise.estimatedCalories} kcal',
                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.neonGreen, size: 20),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
