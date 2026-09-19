import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/progress_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/neon_card.dart';
import '../widgets/interactive_chart_widget.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final profile = context.watch<ProfileProvider>().profile;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;

    final tabs = ['Weight', 'Calories', 'Workouts'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab Selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCardSecondary,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: tabs.map((tab) {
                    final isSelected = tab == progress.selectedTab;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => progress.setSelectedTab(tab),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? AppColors.darkCardSecondary : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: isSelected
                                ? Border.all(color: AppColors.neonGreen.withValues(alpha: 0.5))
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              tab,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.neonGreen
                                    : (isDark ? AppColors.textGrey : AppColors.lightTextSecondary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 18),

              // Metric Banner & Chart Card
              NeonCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              progress.currentMetricValue,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: primaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              progress.currentMetricSubtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neonGreen,
                              ),
                            ),
                          ],
                        ),
                        // Dropdown filter
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCardSecondary : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: progress.selectedTimeFrame,
                              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                              isDense: true,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: primaryText,
                              ),
                              dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                              items: ['This Month', '3 Months', 'This Year']
                                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) progress.setSelectedTimeFrame(val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Chart
                    InteractiveChartWidget(
                      points: progress.currentPoints,
                      unit: progress.selectedTab == 'Weight'
                          ? 'kg'
                          : (progress.selectedTab == 'Calories' ? 'kcal' : 'wo'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4 Stat Grid (2x2) Matching Reference Image
              Row(
                children: [
                  Expanded(
                    child: _StatGridCard(
                      title: 'Workout Streak',
                      value: '${profile.workoutStreak}',
                      unit: 'Days',
                      isHighlight: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatGridCard(
                      title: 'Calories Burned',
                      value: '${profile.caloriesBurnedThisMonth}',
                      unit: 'This Month',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatGridCard(
                      title: 'Total Workouts',
                      value: '${profile.totalWorkouts}',
                      unit: '',
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: _StatGridCard(
                      title: 'Avg. Duration',
                      value: '1h 10m',
                      unit: '',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatGridCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final bool isHighlight;

  const _StatGridCard({
    required this.title,
    required this.value,
    required this.unit,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return NeonCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isHighlight ? AppColors.neonGreen : primaryText,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: secondaryText,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
