import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/workout_models.dart';
import '../providers/workout_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/neon_card.dart';
import '../widgets/custom_button.dart';

class WorkoutTrackingScreen extends StatefulWidget {
  final Exercise exercise;

  const WorkoutTrackingScreen({super.key, required this.exercise});

  @override
  State<WorkoutTrackingScreen> createState() => _WorkoutTrackingScreenState();
}

class _WorkoutTrackingScreenState extends State<WorkoutTrackingScreen> {
  void _editSet(int index, WorkoutSet set) {
    final repsController = TextEditingController(text: set.reps.toString());
    final weightController = TextEditingController(text: set.weightKg.toStringAsFixed(0));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          title: Text('Edit Set ${set.setNumber}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Reps',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen),
              onPressed: () {
                final reps = int.tryParse(repsController.text) ?? set.reps;
                final weight = double.tryParse(weightController.text) ?? set.weightKg;
                final wp = context.read<WorkoutProvider>();
                wp.updateSetReps(index, reps);
                wp.updateSetWeight(index, weight);
                Navigator.pop(ctx);
              },
              child: const Text('Save', style: TextStyle(color: AppColors.darkBg, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _finishWorkout() {
    final wp = context.read<WorkoutProvider>();
    final profile = context.read<ProfileProvider>();
    final item = wp.finishCurrentWorkout();

    profile.incrementWorkoutCompleted(
      caloriesBurned: item.caloriesBurned,
      durationMinutes: item.durationMinutes,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.neonGreen, size: 28),
              SizedBox(width: 10),
              Text('Workout Complete!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Great job finishing ${widget.exercise.name}!',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _SummaryRow(title: 'Completed Sets', value: '${item.completedSets} sets'),
              _SummaryRow(title: 'Total Volume', value: '${item.totalVolumeKg.toInt()} kg'),
              _SummaryRow(title: 'Calories Burned', value: '${item.caloriesBurned} kcal'),
            ],
          ),
          actions: [
            CustomButton(
              text: 'Done',
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();
    final sets = workoutProvider.activeSets;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.neonGreen),
            tooltip: 'Add Set',
            onPressed: () => workoutProvider.addSet(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Sets: ${sets.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: secondaryText,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => workoutProvider.addSet(),
                        icon: const Icon(Icons.add, size: 16, color: AppColors.neonGreen),
                        label: const Text('+ Add Set', style: TextStyle(color: AppColors.neonGreen, fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Sets List
                  ...List.generate(sets.length, (index) {
                    final s = sets[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NeonCard(
                        hasNeonBorder: s.isCompleted,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        onTap: () => _editSet(index, s),
                        child: Row(
                          children: [
                            // Set Number & Reps
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Set ${s.setNumber}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: secondaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${s.reps} Reps',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Weight
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${s.weightKg.toStringAsFixed(0)} kg',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.neonGreen,
                                ),
                              ),
                            ),

                            // Checkbox Button
                            InkWell(
                              onTap: () => workoutProvider.toggleSetCompletion(index),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: s.isCompleted ? AppColors.neonGreen : Colors.transparent,
                                  border: Border.all(
                                    color: s.isCompleted
                                        ? AppColors.neonGreen
                                        : (isDark ? AppColors.darkBorder : Colors.grey.shade400),
                                    width: 2,
                                  ),
                                ),
                                child: s.isCompleted
                                    ? const Icon(Icons.check, size: 20, color: AppColors.darkBg)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Bottom Rest Timer & Finish Workout
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: Border(
                  top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Column(
                children: [
                  // Rest Timer Bar
                  NeonCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rest Timer',
                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              workoutProvider.formattedRestTimer,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: primaryText,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // +30s button
                        TextButton(
                          onPressed: () => workoutProvider.addRestSeconds(30),
                          child: const Text('+30s', style: TextStyle(color: AppColors.neonGreen, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        // Play/Pause button
                        IconButton(
                          onPressed: () => workoutProvider.togglePlayPauseRestTimer(),
                          icon: Icon(
                            workoutProvider.isRestTimerRunning ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            color: AppColors.neonGreen,
                            size: 38,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  CustomButton(
                    text: 'Finish Workout',
                    onPressed: _finishWorkout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  const _SummaryRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
