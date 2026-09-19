import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class NeonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool hasNeonBorder;
  final Color? backgroundColor;
  final double borderRadius;

  const NeonCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.hasNeonBorder = false,
    this.backgroundColor,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final defaultBorder = hasNeonBorder
        ? AppColors.neonGreen.withValues(alpha: 0.6)
        : (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: defaultBorder, width: hasNeonBorder ? 1.5 : 1.0),
        boxShadow: hasNeonBorder
            ? [
                BoxShadow(
                  color: AppColors.neonGreen.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 1,
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
