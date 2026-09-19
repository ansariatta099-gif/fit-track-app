import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_theme.dart';
import 'core/services/storage_service.dart';
import 'providers/theme_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/ai_chat_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final storageService = await StorageService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(storageService),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(storageService),
        ),
        ChangeNotifierProvider<WorkoutProvider>(
          create: (_) => WorkoutProvider(storageService),
        ),
        ChangeNotifierProvider<NutritionProvider>(
          create: (_) => NutritionProvider(storageService),
        ),
        ChangeNotifierProvider<ProgressProvider>(
          create: (_) => ProgressProvider(storageService),
        ),
        ChangeNotifierProvider<AiChatProvider>(
          create: (_) => AiChatProvider(storageService),
        ),
      ],
      child: const FitTrackProApp(),
    ),
  );
}

class FitTrackProApp extends StatelessWidget {
  const FitTrackProApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'FitTrack Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
