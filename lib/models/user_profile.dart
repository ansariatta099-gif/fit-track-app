import 'dart:convert';

class UserProfile {
  final String name;
  final int age;
  final String gender;
  final double heightCm;
  final double weightKg;
  final String goal;
  final String activityLevel;
  final int dailyCalorieGoal;
  final double dailyWaterGoalLiters;
  final int workoutStreak;
  final int totalWorkouts;
  final int caloriesBurnedThisMonth;
  final int activeMinutesToday;
  final bool isMetric;
  final int avatarIndex;

  UserProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.goal,
    this.activityLevel = 'Moderate',
    this.dailyCalorieGoal = 2000,
    this.dailyWaterGoalLiters = 2.0,
    this.workoutStreak = 7,
    this.totalWorkouts = 24,
    this.caloriesBurnedThisMonth = 6540,
    this.activeMinutesToday = 80,
    this.isMetric = true,
    this.avatarIndex = 0,
  });

  UserProfile copyWith({
    String? name,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? goal,
    String? activityLevel,
    int? dailyCalorieGoal,
    double? dailyWaterGoalLiters,
    int? workoutStreak,
    int? totalWorkouts,
    int? caloriesBurnedThisMonth,
    int? activeMinutesToday,
    bool? isMetric,
    int? avatarIndex,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      dailyWaterGoalLiters: dailyWaterGoalLiters ?? this.dailyWaterGoalLiters,
      workoutStreak: workoutStreak ?? this.workoutStreak,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      caloriesBurnedThisMonth: caloriesBurnedThisMonth ?? this.caloriesBurnedThisMonth,
      activeMinutesToday: activeMinutesToday ?? this.activeMinutesToday,
      isMetric: isMetric ?? this.isMetric,
      avatarIndex: avatarIndex ?? this.avatarIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'goal': goal,
      'activityLevel': activityLevel,
      'dailyCalorieGoal': dailyCalorieGoal,
      'dailyWaterGoalLiters': dailyWaterGoalLiters,
      'workoutStreak': workoutStreak,
      'totalWorkouts': totalWorkouts,
      'caloriesBurnedThisMonth': caloriesBurnedThisMonth,
      'activeMinutesToday': activeMinutesToday,
      'isMetric': isMetric,
      'avatarIndex': avatarIndex,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? 'Alex Johnson',
      age: map['age'] ?? 27,
      gender: map['gender'] ?? 'Male',
      heightCm: (map['heightCm'] as num?)?.toDouble() ?? 175.0,
      weightKg: (map['weightKg'] as num?)?.toDouble() ?? 72.5,
      goal: map['goal'] ?? 'Muscle Gain',
      activityLevel: map['activityLevel'] ?? 'Moderate',
      dailyCalorieGoal: map['dailyCalorieGoal'] ?? 2000,
      dailyWaterGoalLiters: (map['dailyWaterGoalLiters'] as num?)?.toDouble() ?? 2.0,
      workoutStreak: map['workoutStreak'] ?? 7,
      totalWorkouts: map['totalWorkouts'] ?? 24,
      caloriesBurnedThisMonth: map['caloriesBurnedThisMonth'] ?? 6540,
      activeMinutesToday: map['activeMinutesToday'] ?? 80,
      isMetric: map['isMetric'] ?? true,
      avatarIndex: map['avatarIndex'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));

  static UserProfile defaultAlex() {
    return UserProfile(
      name: 'Alex Johnson',
      age: 27,
      gender: 'Male',
      heightCm: 175.0,
      weightKg: 72.5,
      goal: 'Muscle Gain',
      activityLevel: 'Moderate',
      dailyCalorieGoal: 2000,
      dailyWaterGoalLiters: 2.0,
      workoutStreak: 7,
      totalWorkouts: 24,
      caloriesBurnedThisMonth: 6540,
      activeMinutesToday: 80,
      avatarIndex: 0,
    );
  }
}
