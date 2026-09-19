import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';
import '../models/workout_models.dart';

class ProgressPoint {
  final String label;
  final double value;
  final String date;

  const ProgressPoint({required this.label, required this.value, required this.date});
}

class ProgressProvider extends ChangeNotifier {
  final StorageService _storageService;
  String _selectedTab = 'Weight';
  String _selectedTimeFrame = 'This Month';

  ProgressProvider(this._storageService);

  String get selectedTab => _selectedTab;
  String get selectedTimeFrame => _selectedTimeFrame;

  void setSelectedTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void setSelectedTimeFrame(String timeFrame) {
    _selectedTimeFrame = timeFrame;
    notifyListeners();
  }

  List<ProgressPoint> get currentPoints {
    if (_selectedTab == 'Weight') {
      final profile = _storageService.getUserProfile();
      return [
        const ProgressPoint(label: '1 Jul', value: 71.0, date: '1 Jul'),
        const ProgressPoint(label: '8 Jul', value: 71.8, date: '8 Jul'),
        const ProgressPoint(label: '15 Jul', value: 71.2, date: '15 Jul'),
        const ProgressPoint(label: '22 Jul', value: 72.0, date: '22 Jul'),
        ProgressPoint(label: 'Today', value: profile.weightKg, date: 'Today'),
      ];
    } else if (_selectedTab == 'Calories') {
      final history = _storageService.getWorkoutHistory();
      final now = DateTime.now();
      double w1 = 0, w2 = 0, w3 = 0, w4 = 0;
      for (WorkoutHistoryItem item in history) {
        final diffDays = now.difference(item.date).inDays;
        if (diffDays < 7) {
          w4 += item.caloriesBurned;
        } else if (diffDays < 14) {
          w3 += item.caloriesBurned;
        } else if (diffDays < 21) {
          w2 += item.caloriesBurned;
        } else if (diffDays < 28) {
          w1 += item.caloriesBurned;
        }
      }
      return [
        ProgressPoint(label: 'W1', value: 1800 + w1, date: 'Week 1'),
        ProgressPoint(label: 'W2', value: 2100 + w2, date: 'Week 2'),
        ProgressPoint(label: 'W3', value: 1950 + w3, date: 'Week 3'),
        ProgressPoint(label: 'W4', value: 2000 + w4, date: 'Week 4'),
      ];
    } else {
      final history = _storageService.getWorkoutHistory();
      final now = DateTime.now();
      double w1 = 0, w2 = 0, w3 = 0, w4 = 0;
      for (WorkoutHistoryItem item in history) {
        final diffDays = now.difference(item.date).inDays;
        if (diffDays < 7) {
          w4++;
        } else if (diffDays < 14) {
          w3++;
        } else if (diffDays < 21) {
          w2++;
        } else if (diffDays < 28) {
          w1++;
        }
      }
      return [
        ProgressPoint(label: 'W1', value: 4 + w1, date: 'Week 1'),
        ProgressPoint(label: 'W2', value: 5 + w2, date: 'Week 2'),
        ProgressPoint(label: 'W3', value: 5 + w3, date: 'Week 3'),
        ProgressPoint(label: 'W4', value: 6 + w4, date: 'Week 4'),
      ];
    }
  }

  String get currentMetricValue {
    final profile = _storageService.getUserProfile();
    if (_selectedTab == 'Weight') return '${profile.weightKg.toStringAsFixed(1)} kg';
    if (_selectedTab == 'Calories') {
      final calories = profile.caloriesBurnedThisMonth;
      return "${calories.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} kcal";
    }
    return '${profile.totalWorkouts} Workouts';
  }

  String get currentMetricSubtitle {
    if (_selectedTab == 'Weight') return 'Current weight updated';
    if (_selectedTab == 'Calories') return 'Total calories burned this month';
    return 'Total workouts completed';
  }
}
