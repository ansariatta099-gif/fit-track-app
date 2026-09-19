import 'package:flutter_test/flutter_test.dart';
import 'package:fittrack_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fittrack_app/core/services/storage_service.dart';
import 'package:fittrack_app/core/utils/fitness_calculators.dart';
import 'package:provider/provider.dart';
import 'package:fittrack_app/providers/theme_provider.dart';
import 'package:fittrack_app/providers/profile_provider.dart';
import 'package:fittrack_app/providers/workout_provider.dart';
import 'package:fittrack_app/providers/nutrition_provider.dart';
import 'package:fittrack_app/providers/progress_provider.dart';
import 'package:fittrack_app/screens/splash_screen.dart';
import 'package:fittrack_app/core/services/fitness_ai_engine.dart';
import 'package:fittrack_app/core/services/gemini_service.dart';

void main() {
  group('Fitness Calculators Tests', () {
    test('BMI calculation for normal range', () {
      final res = FitnessCalculators.calculateBMI(175, 72.5);
      expect(res.bmi, 23.7);
      expect(res.category, 'Normal');
    });

    test('BMR calculation for male', () {
      final bmr = FitnessCalculators.calculateBMR(
        age: 27,
        gender: 'Male',
        heightCm: 175,
        weightKg: 72.5,
      );
      expect(bmr, 1689);
    });

    test('Daily Calorie Goal calculation', () {
      final goal = FitnessCalculators.calculateDailyCalorieGoal(
        age: 27,
        gender: 'Male',
        heightCm: 175,
        weightKg: 72.5,
        activityLevel: 'Moderate',
        goal: 'Muscle Gain',
      );
      expect(goal, greaterThan(2000));
    });
  });

  group('Provider & Storage State Tests', () {
    test('Nutrition Provider water and macro calculations', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final nutrition = NutritionProvider(storage);

      final initialWater = nutrition.waterIntakeLiters;
      nutrition.addWaterGlass(0.25);
      expect(nutrition.waterIntakeLiters, closeTo(initialWater + 0.25, 0.01));

      expect(nutrition.consumedCalories, greaterThan(0));
    });

    test('Workout Provider sets toggle and finish workout', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final workout = WorkoutProvider(storage);

      expect(workout.activeSets.length, 4);
      workout.toggleSetCompletion(0);
      expect(workout.activeSets.first.isCompleted, false);

      workout.addSet();
      expect(workout.activeSets.length, 5);
    });
  });

  group('Fitness AI Coach & Engine Tests', () {
    test('FitnessAiEngine answers Hydration query accurately', () {
      final response = FitnessAiEngine.getResponse('Suggest me some Hydration guidance');
      expect(response, contains('Hydration'));
      expect(response, contains('Daily Water Intake Target'));
    });

    test('FitnessAiEngine answers Roman Urdu queries', () {
      final response = FitnessAiEngine.getResponse('paani kitna peena chahiye');
      expect(response, contains('Hydration'));
      expect(response, contains('Litres'));
    });

    test('FitnessAiEngine answers Workout queries', () {
      final response = FitnessAiEngine.getResponse('Home workout splits');
      expect(response, contains('Workout'));
      expect(response, contains('Push-Ups'));
    });

    test('GeminiService fallback when unconfigured or empty key', () async {
      final geminiService = GeminiService();
      geminiService.initialize('');
      final response = await geminiService.getChatResponse([], 'Suggest me some Hydration guidance');
      expect(response, contains('Hydration'));
    });
  });

  testWidgets('FitTrack Pro App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<StorageService>.value(value: storage),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider(storage)),
          ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider(storage)),
          ChangeNotifierProvider<WorkoutProvider>(create: (_) => WorkoutProvider(storage)),
          ChangeNotifierProvider<NutritionProvider>(create: (_) => NutritionProvider(storage)),
          ChangeNotifierProvider<ProgressProvider>(create: (_) => ProgressProvider(storage)),
        ],
        child: const FitTrackProApp(),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
