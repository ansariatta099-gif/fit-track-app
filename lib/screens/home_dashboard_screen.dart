import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/profile_provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/neon_card.dart';
import '../widgets/circular_goal_widget.dart';
import '../widgets/stat_metric_tile.dart';
import '../widgets/custom_button.dart';
import '../widgets/user_avatar_widget.dart';
import 'exercise_details_screen.dart';
import 'bmi_calculator_screen.dart';
import 'bmr_calculator_screen.dart';
import 'calorie_goal_screen.dart';
import 'settings_screen.dart';
import 'ai_chat_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  final Function(int) onNavigateTab;

  const HomeDashboardScreen({super.key, required this.onNavigateTab});

  void _showMoreActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calculators & Tools',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textWhite : AppColors.lightTextPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                _ToolTile(
                  icon: Icons.speed_rounded,
                  title: 'BMI Calculator',
                  subtitle: 'Calculate Body Mass Index & Category',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BmiCalculatorScreen()));
                  },
                ),
                _ToolTile(
                  icon: Icons.local_fire_department_rounded,
                  title: 'BMR Calculator',
                  subtitle: 'Basal Metabolic Rate at rest',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BmrCalculatorScreen()));
                  },
                ),
                _ToolTile(
                  icon: Icons.track_changes_rounded,
                  title: 'Calorie Goal Calculator',
                  subtitle: 'Daily target based on goal & activity',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CalorieGoalScreen()));
                  },
                ),
                _ToolTile(
                  icon: Icons.settings_rounded,
                  title: 'App Settings',
                  subtitle: 'Themes, units & notification reminders',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final workoutProvider = context.watch<WorkoutProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    final today = DateTime.now();
    final todayWorkouts = workoutProvider.history.where((item) =>
        item.date.year == today.year &&
        item.date.month == today.month &&
        item.date.day == today.day);

    final caloriesBurnedToday = todayWorkouts.fold<int>(0, (sum, item) => sum + item.caloriesBurned);
    final activeMinutesToday = profile.activeMinutesToday;

    const calorieGoalTarget = 500; // Daily active calorie burn goal
    final calorieProgress = (caloriesBurnedToday / calorieGoalTarget).clamp(0.0, 1.0);
    final caloriePercentageStr = '${(calorieProgress * 100).toInt()}%';

    final workoutsThisWeek = workoutProvider.history.where((item) {
      final difference = today.difference(item.date).inDays;
      return difference < 7;
    }).length;

    String formatActiveTime(int minutes) {
      if (minutes <= 0) return '0m';
      if (minutes < 60) return '${minutes}m';
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return m > 0 ? '${h}h ${m}m' : '${h}h';
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Hello, ${profile.name.split(' ').first} 👋',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: primaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ready to crush your goal today?',
                        style: TextStyle(
                          fontSize: 13,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                  UserAvatarWidget(
                    avatarIndex: profile.avatarIndex,
                    size: 44,
                    onTap: () => onNavigateTab(4),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              NeonCard(
                hasNeonBorder: true,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Goal',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: secondaryText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                caloriePercentageStr,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? AppColors.textWhite : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$caloriesBurnedToday / $calorieGoalTarget kcal',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: calorieProgress,
                              backgroundColor: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonGreen),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    CircularGoalWidget(percentage: calorieProgress, size: 56),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  StatMetricTile(
                    title: 'Workouts',
                    value: '$workoutsThisWeek',
                    subtitle: 'This Week',
                  ),
                  const SizedBox(width: 10),
                  StatMetricTile(
                    title: 'Calories',
                    value: '$caloriesBurnedToday',
                    subtitle: 'Burned',
                  ),
                  const SizedBox(width: 10),
                  StatMetricTile(
                    title: 'Active Time',
                    value: formatActiveTime(activeMinutesToday),
                    subtitle: 'Today',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickActionButton(
                    icon: Icons.fitness_center_rounded,
                    label: 'Workout',
                    onTap: () => onNavigateTab(1),
                  ),
                  _QuickActionButton(
                    icon: Icons.restaurant_rounded,
                    label: 'Nutrition',
                    onTap: () => onNavigateTab(3),
                  ),
                  _QuickActionButton(
                    icon: Icons.trending_up_rounded,
                    label: 'Progress',
                    onTap: () => onNavigateTab(2),
                  ),
                  _QuickActionButton(
                    icon: Icons.more_horiz_rounded,
                    label: 'More',
                    onTap: () => _showMoreActions(context),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                "Today's Workout",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 12),
              NeonCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chest & Triceps',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Intermediate • 45 min',
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryText,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: 140,
                            child: CustomButton(
                              height: 38,
                              text: 'Start Workout',
                              borderRadius: 10,
                              onPressed: () {
                                final benchPress = workoutProvider.allExercises.first;
                                workoutProvider.setCurrentExercise(benchPress);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ExerciseDetailsScreen(exercise: benchPress),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.darkCardSecondary,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.neonGreen.withValues(alpha: 0.3)),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.fitness_center_rounded,
                          size: 38,
                          color: AppColors.neonGreen,
                        ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.neonGreen,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: const Icon(Icons.smart_toy_rounded, size: 28),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AiChatScreen()),
          );
        },
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
            ),
            child: Center(
              child: Icon(icon, color: AppColors.neonGreen, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.neonGreen.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.neonGreen, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.textWhite : AppColors.lightTextPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.textGrey : AppColors.lightTextSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
