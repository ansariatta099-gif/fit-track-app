import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_profile.dart';
import '../../models/workout_models.dart';
import '../../models/nutrition_models.dart';

class StorageService {
  static const String keyProfile = 'fittrack_user_profile';
  static const String keyThemeMode = 'fittrack_theme_mode';
  static const String keyWorkoutHistory = 'fittrack_workout_history';
  static const String keyMeals = 'fittrack_today_meals';
  static const String keyWaterIntake = 'fittrack_water_intake';
  static const String keyCompletedSets = 'fittrack_completed_sets';
  static const String keyHasOnboarded = 'fittrack_has_onboarded';
  static const String keyGeminiApiKey = 'fittrack_gemini_api_key';
  static const String keyChatHistory = 'fittrack_chat_history';

  final SharedPreferences prefs;

  StorageService(this.prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Onboarding
  bool get hasOnboarded => prefs.getBool(keyHasOnboarded) ?? false;
  Future<void> setHasOnboarded(bool value) async {
    await prefs.setBool(keyHasOnboarded, value);
  }

  // Profile
  UserProfile getUserProfile() {
    final jsonStr = prefs.getString(keyProfile);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        return UserProfile.fromJson(jsonStr);
      } catch (_) {}
    }
    return UserProfile.defaultAlex();
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await prefs.setString(keyProfile, profile.toJson());
  }

  // Theme Mode
  bool get isDarkMode => prefs.getBool(keyThemeMode) ?? true;
  Future<void> setDarkMode(bool isDark) async {
    await prefs.setBool(keyThemeMode, isDark);
  }

  // Water Intake
  double getWaterIntake() {
    return prefs.getDouble(keyWaterIntake) ?? 1.8;
  }

  Future<void> saveWaterIntake(double liters) async {
    await prefs.setDouble(keyWaterIntake, liters);
  }

  // Meals
  List<MealItem> getMeals() {
    final raw = prefs.getString(keyMeals);
    if (raw != null && raw.isNotEmpty) {
      try {
        final List list = json.decode(raw);
        return list.map((e) => MealItem.fromMap(e)).toList();
      } catch (_) {}
    }
    return [
      MealItem(
        id: '1',
        title: 'Breakfast',
        subtitle: 'Oatmeal with fruits',
        calories: 450,
        proteinGrams: 18,
        carbsGrams: 65,
        fatGrams: 10,
        mealType: 'Breakfast',
        time: '08:30 AM',
      ),
      MealItem(
        id: '2',
        title: 'Lunch',
        subtitle: 'Grilled Chicken Salad',
        calories: 550,
        proteinGrams: 55,
        carbsGrams: 30,
        fatGrams: 18,
        mealType: 'Lunch',
        time: '01:15 PM',
      ),
      MealItem(
        id: '3',
        title: 'Dinner',
        subtitle: 'Salmon with Veggies',
        calories: 650,
        proteinGrams: 48,
        carbsGrams: 35,
        fatGrams: 28,
        mealType: 'Dinner',
        time: '07:45 PM',
      ),
    ];
  }

  Future<void> saveMeals(List<MealItem> meals) async {
    final list = meals.map((m) => m.toMap()).toList();
    await prefs.setString(keyMeals, json.encode(list));
  }

  // Workout History
  List<WorkoutHistoryItem> getWorkoutHistory() {
    final raw = prefs.getString(keyWorkoutHistory);
    if (raw != null && raw.isNotEmpty) {
      try {
        final List list = json.decode(raw);
        return list.map((e) => WorkoutHistoryItem.fromMap(e)).toList();
      } catch (_) {}
    }
    return [
      WorkoutHistoryItem(
        id: 'w1',
        exerciseName: 'Bench Press',
        categoryName: 'Chest',
        completedSets: 4,
        totalReps: 40,
        totalVolumeKg: 1900,
        caloriesBurned: 180,
        durationMinutes: 45,
        date: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      WorkoutHistoryItem(
        id: 'w2',
        exerciseName: 'Barbell Squat',
        categoryName: 'Legs',
        completedSets: 4,
        totalReps: 40,
        totalVolumeKg: 3200,
        caloriesBurned: 270,
        durationMinutes: 50,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<void> saveWorkoutHistory(List<WorkoutHistoryItem> history) async {
    final list = history.map((h) => h.toMap()).toList();
    await prefs.setString(keyWorkoutHistory, json.encode(list));
  }

  // Gemini AI Chat
  String getGeminiApiKey() {
    return prefs.getString(keyGeminiApiKey) ?? '';
  }

  Future<void> saveGeminiApiKey(String apiKey) async {
    await prefs.setString(keyGeminiApiKey, apiKey);
  }

  String getChatHistoryJson() {
    return prefs.getString(keyChatHistory) ?? '[]';
  }

  Future<void> saveChatHistoryJson(String jsonStr) async {
    await prefs.setString(keyChatHistory, jsonStr);
  }
}
