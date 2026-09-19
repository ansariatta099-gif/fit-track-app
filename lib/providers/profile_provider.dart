import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../core/services/storage_service.dart';

class ProfileProvider extends ChangeNotifier {
  final StorageService _storageService;
  late UserProfile _profile;

  ProfileProvider(this._storageService) {
    _profile = _storageService.getUserProfile();
  }

  UserProfile get profile => _profile;

  void updateProfile(UserProfile updated) {
    _profile = updated;
    _storageService.saveUserProfile(_profile);
    notifyListeners();
  }

  void updateAvatarIndex(int index) {
    _profile = _profile.copyWith(avatarIndex: index);
    _storageService.saveUserProfile(_profile);
    notifyListeners();
  }

  void updateWeight(double newWeightKg) {
    _profile = _profile.copyWith(weightKg: newWeightKg);
    _storageService.saveUserProfile(_profile);
    notifyListeners();
  }

  void updateHeight(double newHeightCm) {
    _profile = _profile.copyWith(heightCm: newHeightCm);
    _storageService.saveUserProfile(_profile);
    notifyListeners();
  }

  void updateGoal(String newGoal) {
    _profile = _profile.copyWith(goal: newGoal);
    _storageService.saveUserProfile(_profile);
    notifyListeners();
  }

  void incrementWorkoutCompleted({required int caloriesBurned, required int durationMinutes}) {
    _profile = _profile.copyWith(
      totalWorkouts: _profile.totalWorkouts + 1,
      workoutStreak: _profile.workoutStreak + 1,
      caloriesBurnedThisMonth: _profile.caloriesBurnedThisMonth + caloriesBurned,
      activeMinutesToday: _profile.activeMinutesToday + durationMinutes,
    );
    _storageService.saveUserProfile(_profile);
    notifyListeners();
  }

  void toggleUnitSystem() {
    _profile = _profile.copyWith(isMetric: !_profile.isMetric);
    _storageService.saveUserProfile(_profile);
    notifyListeners();
  }
}
