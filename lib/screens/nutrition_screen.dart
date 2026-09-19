import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/nutrition_models.dart';
import '../providers/nutrition_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/neon_card.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  void _showAddMealDialog(BuildContext context) {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();
    String selectedType = 'Breakfast';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Log Meal',
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
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedType,
                      decoration: const InputDecoration(labelText: 'Meal Type', border: OutlineInputBorder()),
                      items: ['Breakfast', 'Lunch', 'Dinner', 'Snacks']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedType = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Meal Name (e.g. Protein Shake)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: subtitleController,
                      decoration: const InputDecoration(labelText: 'Description (e.g. Whey + Oats)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: caloriesController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Calories (kcal)', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: proteinController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Protein (g)', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: carbsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Carbs (g)', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: fatController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Fat (g)', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final title = titleController.text.trim().isNotEmpty ? titleController.text.trim() : selectedType;
                          final subtitle = subtitleController.text.trim().isNotEmpty ? subtitleController.text.trim() : 'Custom log';
                          final cal = int.tryParse(caloriesController.text) ?? 300;
                          final prot = double.tryParse(proteinController.text) ?? 20.0;
                          final carbs = double.tryParse(carbsController.text) ?? 30.0;
                          final fat = double.tryParse(fatController.text) ?? 10.0;

                          final meal = MealItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: title,
                            subtitle: subtitle,
                            calories: cal,
                            proteinGrams: prot,
                            carbsGrams: carbs,
                            fatGrams: fat,
                            mealType: selectedType,
                            time: 'Just now',
                          );

                          context.read<NutritionProvider>().addMeal(meal);
                          Navigator.pop(ctx);
                        },
                        child: const Text(
                          'Add Meal',
                          style: TextStyle(color: AppColors.darkBg, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nutrition = context.watch<NutritionProvider>();
    context.watch<ProfileProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.neonGreen),
            tooltip: 'Add Meal',
            onPressed: () => _showAddMealDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeonCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Overview',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: secondaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          nutrition.consumedCalories.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: primaryText,
                          ),
                        ),
                        Text(
                          ' / ${nutrition.targetCalories} kcal',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: nutrition.calorieProgress,
                        backgroundColor: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonGreen),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _MacroItem(
                          label: 'Protein',
                          current: '${nutrition.consumedProtein.toInt()}',
                          target: '${nutrition.targetProtein.toInt()} g',
                          color: AppColors.proteinRed,
                        ),
                        _MacroItem(
                          label: 'Carbs',
                          current: '${nutrition.consumedCarbs.toInt()}',
                          target: '${nutrition.targetCarbs.toInt()} g',
                          color: AppColors.carbsYellow,
                        ),
                        _MacroItem(
                          label: 'Fat',
                          current: '${nutrition.consumedFat.toInt()}',
                          target: '${nutrition.targetFat.toInt()} g',
                          color: AppColors.fatBlue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              NeonCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Water Intake',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: secondaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${nutrition.waterIntakeLiters.toStringAsFixed(1)} / ${nutrition.waterTargetLiters.toStringAsFixed(1)} L',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: primaryText,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => nutrition.addWaterGlass(0.25),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.waterBlue.withValues(alpha: 0.15),
                              border: Border.all(color: AppColors.waterBlue, width: 1.5),
                            ),
                            child: const Icon(Icons.add, color: AppColors.waterBlue, size: 22),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(8, (index) {
                        final cupThreshold = (index + 1) * 0.25;
                        final isFilled = nutrition.waterIntakeLiters >= (cupThreshold - 0.05);

                        return GestureDetector(
                          onTap: () {
                            if (isFilled) {
                              nutrition.removeWaterGlass(0.25);
                            } else {
                              nutrition.addWaterGlass(0.25);
                            }
                          },
                          child: Icon(
                            isFilled ? Icons.water_drop_rounded : Icons.water_drop_outlined,
                            color: isFilled ? AppColors.waterBlue : (isDark ? AppColors.darkBorder : Colors.grey.shade400),
                            size: 26,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meals',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddMealDialog(context),
                    icon: const Icon(Icons.add, size: 16, color: AppColors.neonGreen),
                    label: const Text('+ Add Meal', style: TextStyle(color: AppColors.neonGreen, fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              ...nutrition.meals.map((meal) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NeonCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCardSecondary : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.neonGreen.withValues(alpha: 0.3)),
                          ),
                          child: const Center(
                            child: Icon(Icons.restaurant_menu_rounded, color: AppColors.neonGreen, size: 22),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: primaryText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                meal.subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${meal.calories} kcal',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.neonGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String current;
  final String target;
  final Color color;

  const _MacroItem({
    required this.label,
    required this.current,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$current / $target',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textWhite : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
