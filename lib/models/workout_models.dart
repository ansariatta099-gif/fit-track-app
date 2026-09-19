import 'dart:convert';

class WorkoutCategory {
  final String id;
  final String name;
  final int exerciseCount;
  final String iconCode;
  final String description;

  const WorkoutCategory({
    required this.id,
    required this.name,
    required this.exerciseCount,
    required this.iconCode,
    required this.description,
  });
}

class Exercise {
  final String id;
  final String name;
  final String categoryId;
  final String muscleGroup;
  final String equipment;
  final String difficulty;
  final String description;
  final int defaultSets;
  final int defaultReps;
  final double defaultWeightKg;
  final int estimatedCalories;
  final int durationMinutes;

  const Exercise({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    required this.description,
    this.defaultSets = 4,
    this.defaultReps = 10,
    this.defaultWeightKg = 50.0,
    this.estimatedCalories = 180,
    this.durationMinutes = 45,
  });
}

class WorkoutSet {
  final int setNumber;
  int reps;
  double weightKg;
  bool isCompleted;

  WorkoutSet({
    required this.setNumber,
    required this.reps,
    required this.weightKg,
    this.isCompleted = false,
  });

  WorkoutSet copyWith({
    int? setNumber,
    int? reps,
    double? weightKg,
    bool? isCompleted,
  }) {
    return WorkoutSet(
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'setNumber': setNumber,
      'reps': reps,
      'weightKg': weightKg,
      'isCompleted': isCompleted,
    };
  }

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      setNumber: map['setNumber'] ?? 1,
      reps: map['reps'] ?? 10,
      weightKg: (map['weightKg'] as num?)?.toDouble() ?? 40.0,
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

class WorkoutHistoryItem {
  final String id;
  final String exerciseName;
  final String categoryName;
  final int completedSets;
  final int totalReps;
  final double totalVolumeKg;
  final int caloriesBurned;
  final int durationMinutes;
  final DateTime date;

  WorkoutHistoryItem({
    required this.id,
    required this.exerciseName,
    required this.categoryName,
    required this.completedSets,
    required this.totalReps,
    required this.totalVolumeKg,
    required this.caloriesBurned,
    required this.durationMinutes,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseName': exerciseName,
      'categoryName': categoryName,
      'completedSets': completedSets,
      'totalReps': totalReps,
      'totalVolumeKg': totalVolumeKg,
      'caloriesBurned': caloriesBurned,
      'durationMinutes': durationMinutes,
      'date': date.toIso8601String(),
    };
  }

  factory WorkoutHistoryItem.fromMap(Map<String, dynamic> map) {
    return WorkoutHistoryItem(
      id: map['id'] ?? '',
      exerciseName: map['exerciseName'] ?? '',
      categoryName: map['categoryName'] ?? '',
      completedSets: map['completedSets'] ?? 0,
      totalReps: map['totalReps'] ?? 0,
      totalVolumeKg: (map['totalVolumeKg'] as num?)?.toDouble() ?? 0.0,
      caloriesBurned: map['caloriesBurned'] ?? 0,
      durationMinutes: map['durationMinutes'] ?? 45,
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());
  factory WorkoutHistoryItem.fromJson(String source) => WorkoutHistoryItem.fromMap(json.decode(source));
}
