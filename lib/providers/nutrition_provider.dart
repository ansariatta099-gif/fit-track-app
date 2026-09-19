import 'package:flutter/material.dart';
import '../models/nutrition_models.dart';
import '../core/services/storage_service.dart';

class NutritionProvider extends ChangeNotifier {
  final StorageService _storageService;

  late List<MealItem> _meals;
  late double _waterIntakeLiters;
  final double _waterTargetLiters = 2.0;

  NutritionProvider(this._storageService) {
    _meals = _storageService.getMeals();
    _waterIntakeLiters = _storageService.getWaterIntake();
  }

  List<MealItem> get meals => _meals;
  double get waterIntakeLiters => _waterIntakeLiters;
  double get waterTargetLiters => _waterTargetLiters;

  int get targetCalories => _storageService.getUserProfile().dailyCalorieGoal;
  double get targetProtein => double.parse(((targetCalories * 0.30) / 4.0).toStringAsFixed(1));
  double get targetCarbs => double.parse(((targetCalories * 0.50) / 4.0).toStringAsFixed(1));
  double get targetFat => double.parse(((targetCalories * 0.20) / 9.0).toStringAsFixed(1));

  int get consumedCalories => _meals.fold(0, (sum, item) => sum + item.calories);
  double get consumedProtein => _meals.fold(0.0, (sum, item) => sum + item.proteinGrams);
  double get consumedCarbs => _meals.fold(0.0, (sum, item) => sum + item.carbsGrams);
  double get consumedFat => _meals.fold(0.0, (sum, item) => sum + item.fatGrams);

  double get calorieProgress => (targetCalories > 0) ? (consumedCalories / targetCalories).clamp(0.0, 1.0) : 0.0;
  double get waterProgress => (_waterTargetLiters > 0) ? (_waterIntakeLiters / _waterTargetLiters).clamp(0.0, 1.0) : 0.0;

  void addWaterGlass([double glassAmount = 0.25]) {
    _waterIntakeLiters = double.parse((_waterIntakeLiters + glassAmount).toStringAsFixed(2));
    _storageService.saveWaterIntake(_waterIntakeLiters);
    notifyListeners();
  }

  void removeWaterGlass([double glassAmount = 0.25]) {
    if (_waterIntakeLiters >= glassAmount) {
      _waterIntakeLiters = double.parse((_waterIntakeLiters - glassAmount).toStringAsFixed(2));
      _storageService.saveWaterIntake(_waterIntakeLiters);
      notifyListeners();
    }
  }

  void addMeal(MealItem meal) {
    _meals.add(meal);
    _storageService.saveMeals(_meals);
    notifyListeners();
  }

  void removeMeal(String mealId) {
    _meals.removeWhere((m) => m.id == mealId);
    _storageService.saveMeals(_meals);
    notifyListeners();
  }
}
