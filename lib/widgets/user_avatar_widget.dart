import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/profile_provider.dart';

class AvatarPreset {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final String subtitle;

  const AvatarPreset({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.subtitle,
  });
}

class AvatarData {
  static const List<AvatarPreset> presets = [
    AvatarPreset(
      label: 'Alex (Athlete)',
      icon: Icons.face_rounded,
      bgColor: Color(0xFF1E293B),
      iconColor: AppColors.neonGreen,
      subtitle: 'Fitness Male',
    ),
    AvatarPreset(
      label: 'Bodybuilder',
      icon: Icons.fitness_center_rounded,
      bgColor: Color(0xFF27272A),
      iconColor: Color(0xFFFFB300),
      subtitle: 'Heavy Lifter',
    ),
    AvatarPreset(
      label: 'Runner',
      icon: Icons.directions_run_rounded,
      bgColor: Color(0xFF0F172A),
      iconColor: Color(0xFF38BDF8),
      subtitle: 'Cardio & Speed',
    ),
    AvatarPreset(
      label: 'Gym Beast',
      icon: Icons.sports_gymnastics_rounded,
      bgColor: Color(0xFF18181B),
      iconColor: Color(0xFFFF5252),
      subtitle: 'Powerlifter',
    ),
    AvatarPreset(
      label: 'CrossFit Female',
      icon: Icons.sports_mma_rounded,
      bgColor: Color(0xFF1E1B4B),
      iconColor: Color(0xFFE879F9),
      subtitle: 'Functional Fit',
    ),
    AvatarPreset(
      label: 'Calisthenics',
      icon: Icons.accessibility_new_rounded,
      bgColor: Color(0xFF042F2E),
      iconColor: Color(0xFF2DD4BF),
      subtitle: 'Bodyweight Pro',
    ),
    AvatarPreset(
      label: 'Yoga & Core',
      icon: Icons.self_improvement_rounded,
      bgColor: Color(0xFF312E81),
      iconColor: Color(0xFFA78BFA),
      subtitle: 'Flexibility',
    ),
    AvatarPreset(
      label: 'Coach',
      icon: Icons.sports_rounded,
      bgColor: Color(0xFF3F3F46),
      iconColor: Color(0xFFFFFFFF),
      subtitle: 'Trainer',
    ),
  ];
}

class UserAvatarWidget extends StatelessWidget {
  final int avatarIndex;
  final double size;
  final bool showBorder;
  final VoidCallback? onTap;

  const UserAvatarWidget({
    super.key,
    required this.avatarIndex,
    this.size = 44,
    this.showBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final validIndex = (avatarIndex >= 0 && avatarIndex < AvatarData.presets.length) ? avatarIndex : 0;
    final preset = AvatarData.presets[validIndex];

    final widgetChild = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: preset.bgColor,
        border: showBorder ? Border.all(color: AppColors.neonGreen, width: size > 60 ? 2.5 : 2.0) : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: AppColors.neonGreen.withValues(alpha: 0.25),
                  blurRadius: 8,
                  spreadRadius: 0.5,
                )
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          preset.icon,
          color: preset.iconColor,
          size: size * 0.52,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: widgetChild,
      );
    }
    return widgetChild;
  }

  static void showAvatarPicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profileProvider = context.read<ProfileProvider>();
    final currentIndex = profileProvider.profile.avatarIndex;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose Profile Avatar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textWhite : AppColors.lightTextPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Select your preferred fitness character avatar',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textGrey : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: AvatarData.presets.length,
                  itemBuilder: (context, index) {
                    final p = AvatarData.presets[index];
                    final isSelected = index == currentIndex;

                    return GestureDetector(
                      onTap: () {
                        profileProvider.updateAvatarIndex(index);
                        Navigator.pop(ctx);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: p.bgColor,
                              border: Border.all(
                                color: isSelected ? AppColors.neonGreen : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                                width: isSelected ? 3.0 : 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.neonGreen.withValues(alpha: 0.4),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(p.icon, color: p.iconColor, size: 28),
                                if (isSelected)
                                  Positioned(
                                    right: 2,
                                    bottom: 2,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: AppColors.neonGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check, size: 11, color: AppColors.darkBg),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.label.split(' ').first,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppColors.neonGreen : (isDark ? AppColors.textWhite : AppColors.lightTextPrimary),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
