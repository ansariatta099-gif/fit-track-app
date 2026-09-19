import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/workout_provider.dart';
import '../widgets/neon_card.dart';
import 'exercise_list_screen.dart';

class WorkoutCategoriesScreen extends StatelessWidget {
  const WorkoutCategoriesScreen({super.key});

  IconData _getCategoryIcon(String id) {
    switch (id) {
      case 'chest':
        return Icons.fitness_center_rounded;
      case 'back':
        return Icons.sports_gymnastics_rounded;
      case 'legs':
        return Icons.directions_run_rounded;
      case 'shoulders':
        return Icons.accessibility_new_rounded;
      case 'arms':
        return Icons.sports_mma_rounded;
      case 'core':
        return Icons.self_improvement_rounded;
      case 'full_body':
        return Icons.flash_on_rounded;
      default:
        return Icons.fitness_center_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<WorkoutProvider>().categories;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 14),
            ...categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NeonCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExerciseListScreen(category: cat),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardSecondary : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.neonGreen.withValues(alpha: 0.3)),
                        ),
                        child: Center(
                          child: Icon(
                            _getCategoryIcon(cat.id),
                            color: AppColors.neonGreen,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: primaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${cat.exerciseCount} Exercises',
                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: secondaryText,
                        size: 22,
                      ),
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
