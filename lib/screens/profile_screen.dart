import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/profile_provider.dart';
import '../widgets/neon_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/user_avatar_widget.dart';
import 'edit_profile_screen.dart';
import 'bmi_calculator_screen.dart';
import 'bmr_calculator_screen.dart';
import 'calorie_goal_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Avatar with camera edit badge
              Center(
                child: Stack(
                  children: [
                    UserAvatarWidget(
                      avatarIndex: profile.avatarIndex,
                      size: 96,
                      onTap: () => UserAvatarWidget.showAvatarPicker(context),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => UserAvatarWidget.showAvatarPicker(context),
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.neonGreen,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.darkBg : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(Icons.camera_alt, size: 16, color: AppColors.darkBg),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Text(
                profile.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => UserAvatarWidget.showAvatarPicker(context),
                child: const Text(
                  'Tap to change avatar',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neonGreen,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              NeonCard(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: Column(
                  children: [
                    _ProfileInfoRow(title: 'Age', value: '${profile.age}'),
                    const Divider(height: 1),
                    _ProfileInfoRow(title: 'Height', value: '${profile.heightCm.toInt()} cm'),
                    const Divider(height: 1),
                    _ProfileInfoRow(title: 'Weight', value: '${profile.weightKg.toStringAsFixed(1)} kg'),
                    const Divider(height: 1),
                    _ProfileInfoRow(title: 'Goal', value: profile.goal),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: 'Edit Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Health & Fitness Tools',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              _ToolItem(
                icon: Icons.speed_rounded,
                title: 'BMI Calculator',
                subtitle: 'Body Mass Index gauge & status',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const BmiCalculatorScreen()));
                },
              ),
              const SizedBox(height: 10),
              _ToolItem(
                icon: Icons.local_fire_department_rounded,
                title: 'BMR Calculator',
                subtitle: 'Basal Metabolic Rate at rest',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const BmrCalculatorScreen()));
                },
              ),
              const SizedBox(height: 10),
              _ToolItem(
                icon: Icons.track_changes_rounded,
                title: 'Calorie Goal Calculator',
                subtitle: 'Target daily energy balance',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CalorieGoalScreen()));
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileInfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textGrey : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textWhite : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ToolItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return NeonCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neonGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.neonGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: secondaryText, size: 22),
        ],
      ),
    );
  }
}
