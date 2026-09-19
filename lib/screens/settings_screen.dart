import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/theme_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/neon_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _workoutReminder = true;
  bool _waterReminder = true;
  bool _dailyGoalReminder = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            _SectionHeader(title: 'General'),
            NeonCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Units', style: TextStyle(fontWeight: FontWeight.w600, color: primaryText)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profileProvider.profile.isMetric ? 'Metric (kg, cm)' : 'Imperial (lb, ft)',
                      style: TextStyle(color: secondaryText, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
                onTap: () {
                  profileProvider.toggleUnitSystem();
                },
              ),
            ),

            const SizedBox(height: 20),

            _SectionHeader(title: 'Reminders'),
            NeonCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                children: [
                  _ReminderToggle(
                    title: 'Workout Reminder',
                    value: _workoutReminder,
                    onChanged: (v) => setState(() => _workoutReminder = v),
                  ),
                  const Divider(height: 1),
                  _ReminderToggle(
                    title: 'Water Reminder',
                    value: _waterReminder,
                    onChanged: (v) => setState(() => _waterReminder = v),
                  ),
                  const Divider(height: 1),
                  _ReminderToggle(
                    title: 'Daily Goal Reminder',
                    value: _dailyGoalReminder,
                    onChanged: (v) => setState(() => _dailyGoalReminder = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _SectionHeader(title: 'Theme'),
            NeonCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Theme Mode', style: TextStyle(fontWeight: FontWeight.w600, color: primaryText)),
                subtitle: Text(
                  themeProvider.isDarkMode ? 'Dark Mode (Black + Neon Green)' : 'Light Mode (White + Green)',
                  style: TextStyle(color: secondaryText, fontSize: 12),
                ),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  activeTrackColor: AppColors.neonGreen.withValues(alpha: 0.4),
                  activeThumbColor: AppColors.neonGreen,
                  onChanged: (val) {
                    themeProvider.setDarkMode(val);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            _SectionHeader(title: 'About App'),
            NeonCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('FitTrack Pro', style: TextStyle(fontWeight: FontWeight.w700, color: primaryText)),
                      const Text('v1.0.0 (Offline)', style: TextStyle(color: AppColors.neonGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '100% offline fitness, workout and nutrition tracking. No cloud data collection.',
                    style: TextStyle(color: secondaryText, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textGrey : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}

class _ReminderToggle extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const _ReminderToggle({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textWhite : AppColors.lightTextPrimary,
          ),
        ),
        Row(
          children: [
            Text(
              value ? 'On' : 'Off',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: value ? AppColors.neonGreen : (isDark ? AppColors.textMuted : AppColors.lightTextSecondary),
              ),
            ),
            Switch(
              value: value,
              activeTrackColor: AppColors.neonGreen.withValues(alpha: 0.4),
              activeThumbColor: AppColors.neonGreen,
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    );
  }
}
