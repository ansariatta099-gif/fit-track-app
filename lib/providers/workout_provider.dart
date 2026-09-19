import 'dart:async';
import 'package:flutter/material.dart';
import '../models/workout_models.dart';
import '../core/services/storage_service.dart';

class WorkoutProvider extends ChangeNotifier {
  final StorageService _storageService;

  final List<WorkoutCategory> _categories = const [
    WorkoutCategory(
      id: 'chest',
      name: 'Chest',
      exerciseCount: 8,
      iconCode: 'fitness_center',
      description: 'Build upper and lower chest strength and definition.',
    ),
    WorkoutCategory(
      id: 'back',
      name: 'Back',
      exerciseCount: 10,
      iconCode: 'sports_gymnastics',
      description: 'Strengthen lats, traps, and improve your posture.',
    ),
    WorkoutCategory(
      id: 'legs',
      name: 'Legs',
      exerciseCount: 12,
      iconCode: 'directions_run',
      description: 'Target quads, hamstrings, glutes, and calves.',
    ),
    WorkoutCategory(
      id: 'shoulders',
      name: 'Shoulders',
      exerciseCount: 7,
      iconCode: 'accessibility_new',
      description: 'Develop full anterior, lateral, and rear deltoids.',
    ),
    WorkoutCategory(
      id: 'arms',
      name: 'Arms',
      exerciseCount: 9,
      iconCode: 'sports_mma',
      description: 'Biceps peaks, triceps thickness, and forearms.',
    ),
    WorkoutCategory(
      id: 'core',
      name: 'Core',
      exerciseCount: 6,
      iconCode: 'self_improvement',
      description: 'Strengthen abs, obliques, and rotational power.',
    ),
    WorkoutCategory(
      id: 'full_body',
      name: 'Full Body',
      exerciseCount: 14,
      iconCode: 'flash_on',
      description: 'High-intensity compound functional training.',
    ),
  ];

  final List<Exercise> _allExercises = const [
    Exercise(
      id: 'bench_press',
      name: 'Bench Press',
      categoryId: 'chest',
      muscleGroup: 'Chest • Shoulders • Triceps',
      equipment: 'Barbell • Bench',
      difficulty: 'Intermediate',
      description: 'A compound exercise that strengthens the chest, shoulders, and triceps. Keep shoulder blades pinched, feet flat on the floor, and press explosively with control.',
      defaultSets: 4,
      defaultReps: 10,
      defaultWeightKg: 40.0,
      estimatedCalories: 180,
      durationMinutes: 45,
    ),
    Exercise(
      id: 'incline_dumbbell_press',
      name: 'Incline Dumbbell Press',
      categoryId: 'chest',
      muscleGroup: 'Upper Chest • Deltoids',
      equipment: 'Dumbbells • Incline Bench',
      difficulty: 'Intermediate',
      description: 'Focuses on the clavicular head of the pectoralis major. Keep a 30-45 degree incline for maximum activation.',
      defaultSets: 4,
      defaultReps: 12,
      defaultWeightKg: 22.0,
      estimatedCalories: 150,
      durationMinutes: 35,
    ),
    Exercise(
      id: 'cable_crossover',
      name: 'Cable Fly / Crossover',
      categoryId: 'chest',
      muscleGroup: 'Chest (Sternal Head)',
      equipment: 'Cable Machine',
      difficulty: 'Beginner',
      description: 'Provides constant tension on the pectoral fibers through the full range of motion.',
      defaultSets: 3,
      defaultReps: 15,
      defaultWeightKg: 15.0,
      estimatedCalories: 120,
      durationMinutes: 30,
    ),
    Exercise(
      id: 'pushups',
      name: 'Push-ups',
      categoryId: 'chest',
      muscleGroup: 'Chest • Triceps • Core',
      equipment: 'Bodyweight',
      difficulty: 'Beginner',
      description: 'Classic functional movement. Keep core engaged and elbows tucked at 45 degrees.',
      defaultSets: 3,
      defaultReps: 20,
      defaultWeightKg: 0.0,
      estimatedCalories: 90,
      durationMinutes: 20,
    ),
    Exercise(
      id: 'pull_ups',
      name: 'Pull-ups',
      categoryId: 'back',
      muscleGroup: 'Lats • Biceps • Upper Back',
      equipment: 'Pull-up Bar',
      difficulty: 'Intermediate',
      description: 'The king of upper body vertical pulling. Pull your elbows down towards your hips.',
      defaultSets: 4,
      defaultReps: 8,
      defaultWeightKg: 0.0,
      estimatedCalories: 140,
      durationMinutes: 30,
    ),
    Exercise(
      id: 'barbell_row',
      name: 'Barbell Bent-Over Row',
      categoryId: 'back',
      muscleGroup: 'Lats • Rhomboids • Traps',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: 'Hinge at hips, keep spine neutral, pull barbell to lower ribcage.',
      defaultSets: 4,
      defaultReps: 10,
      defaultWeightKg: 50.0,
      estimatedCalories: 170,
      durationMinutes: 40,
    ),
    Exercise(
      id: 'deadlift',
      name: 'Conventional Deadlift',
      categoryId: 'back',
      muscleGroup: 'Posterior Chain • Back • Glutes',
      equipment: 'Barbell • Plates',
      difficulty: 'Advanced',
      description: 'Heavy compound lift building total posterior body strength. Drive through heels.',
      defaultSets: 4,
      defaultReps: 6,
      defaultWeightKg: 90.0,
      estimatedCalories: 260,
      durationMinutes: 45,
    ),
    Exercise(
      id: 'barbell_squat',
      name: 'Barbell Back Squat',
      categoryId: 'legs',
      muscleGroup: 'Quads • Glutes • Hamstrings',
      equipment: 'Barbell • Squat Rack',
      difficulty: 'Advanced',
      description: 'Fundamental lower body strength movement. Break at hips and knees, descend below parallel.',
      defaultSets: 4,
      defaultReps: 10,
      defaultWeightKg: 70.0,
      estimatedCalories: 240,
      durationMinutes: 45,
    ),
    Exercise(
      id: 'romanian_deadlift',
      name: 'Romanian Deadlift (RDL)',
      categoryId: 'legs',
      muscleGroup: 'Hamstrings • Glutes',
      equipment: 'Barbell / Dumbbells',
      difficulty: 'Intermediate',
      description: 'Hinge at the hips with slight knee bend to stretch and load the hamstrings.',
      defaultSets: 4,
      defaultReps: 12,
      defaultWeightKg: 55.0,
      estimatedCalories: 180,
      durationMinutes: 35,
    ),
    Exercise(
      id: 'overhead_press',
      name: 'Overhead Barbell Press',
      categoryId: 'shoulders',
      muscleGroup: 'Anterior Deltoid • Triceps',
      equipment: 'Barbell',
      difficulty: 'Intermediate',
      description: 'Press barbell directly overhead with tight core and glutes.',
      defaultSets: 4,
      defaultReps: 8,
      defaultWeightKg: 35.0,
      estimatedCalories: 140,
      durationMinutes: 35,
    ),
    Exercise(
      id: 'lateral_raises',
      name: 'Dumbbell Lateral Raise',
      categoryId: 'shoulders',
      muscleGroup: 'Lateral Deltoids',
      equipment: 'Dumbbells',
      difficulty: 'Beginner',
      description: 'Raise dumbbells to shoulder height with a slight forward lean for round deltoids.',
      defaultSets: 4,
      defaultReps: 15,
      defaultWeightKg: 10.0,
      estimatedCalories: 110,
      durationMinutes: 25,
    ),
    Exercise(
      id: 'barbell_curl',
      name: 'Barbell Bicep Curl',
      categoryId: 'arms',
      muscleGroup: 'Biceps Brachii',
      equipment: 'Barbell / EZ Bar',
      difficulty: 'Beginner',
      description: 'Strict bicep isolation without swinging hips or shoulders.',
      defaultSets: 4,
      defaultReps: 12,
      defaultWeightKg: 25.0,
      estimatedCalories: 120,
      durationMinutes: 30,
    ),
    Exercise(
      id: 'tricep_rope_pushdown',
      name: 'Triceps Rope Pushdown',
      categoryId: 'arms',
      muscleGroup: 'Triceps (Lateral & Medial Head)',
      equipment: 'Cable Machine • Rope Attachment',
      difficulty: 'Beginner',
      description: 'Push down and spread the rope ends at the bottom for intense contraction.',
      defaultSets: 4,
      defaultReps: 12,
      defaultWeightKg: 20.0,
      estimatedCalories: 110,
      durationMinutes: 25,
    ),
    Exercise(
      id: 'hanging_leg_raise',
      name: 'Hanging Leg Raise',
      categoryId: 'core',
      muscleGroup: 'Lower Abs • Hip Flexors',
      equipment: 'Pull-up Bar',
      difficulty: 'Intermediate',
      description: 'Hang straight and raise legs up to 90 degrees or touch the bar without swinging.',
      defaultSets: 3,
      defaultReps: 15,
      defaultWeightKg: 0.0,
      estimatedCalories: 90,
      durationMinutes: 20,
    ),
    Exercise(
      id: 'plank',
      name: 'Core Plank Hold',
      categoryId: 'core',
      muscleGroup: 'Transverse Abdominis • Core',
      equipment: 'Mat',
      difficulty: 'Beginner',
      description: 'Maintain a straight plank line from head to heels for maximum stability.',
      defaultSets: 3,
      defaultReps: 60,
      defaultWeightKg: 0.0,
      estimatedCalories: 70,
      durationMinutes: 15,
    ),
    Exercise(
      id: 'kettlebell_swing',
      name: 'Kettlebell Swings',
      categoryId: 'full_body',
      muscleGroup: 'Hips • Glutes • Back • Shoulders',
      equipment: 'Kettlebell',
      difficulty: 'Intermediate',
      description: 'Explosive hip hinge movement driving the kettlebell up to chest height.',
      defaultSets: 4,
      defaultReps: 20,
      defaultWeightKg: 20.0,
      estimatedCalories: 190,
      durationMinutes: 30,
    ),
  ];

  Exercise? _currentExercise;
  List<WorkoutSet> _activeSets = [];
  late List<WorkoutHistoryItem> _history;

  int _restSecondsRemaining = 45;
  int _restDurationTotal = 45;
  bool _isRestTimerRunning = false;
  Timer? _restTimer;

  WorkoutProvider(this._storageService) {
    _history = _storageService.getWorkoutHistory();
    _currentExercise = _allExercises.first;
    _initActiveSets();
  }

  List<WorkoutCategory> get categories => _categories;
  List<Exercise> get allExercises => _allExercises;
  Exercise? get currentExercise => _currentExercise;
  List<WorkoutSet> get activeSets => _activeSets;
  List<WorkoutHistoryItem> get history => _history;

  int get restSecondsRemaining => _restSecondsRemaining;
  int get restDurationTotal => _restDurationTotal;
  bool get isRestTimerRunning => _isRestTimerRunning;

  String get formattedRestTimer {
    final m = (_restSecondsRemaining ~/ 60).toString().padLeft(2, '0');
    final s = (_restSecondsRemaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  List<Exercise> getExercisesByCategory(String categoryId) {
    return _allExercises.where((e) => e.categoryId == categoryId).toList();
  }

  void setCurrentExercise(Exercise exercise) {
    _currentExercise = exercise;
    _initActiveSets();
    notifyListeners();
  }

  void _initActiveSets() {
    if (_currentExercise?.id == 'bench_press') {
      _activeSets = [
        WorkoutSet(setNumber: 1, reps: 10, weightKg: 40.0, isCompleted: true),
        WorkoutSet(setNumber: 2, reps: 10, weightKg: 50.0, isCompleted: true),
        WorkoutSet(setNumber: 3, reps: 8, weightKg: 60.0, isCompleted: true),
        WorkoutSet(setNumber: 4, reps: 12, weightKg: 40.0, isCompleted: false),
      ];
    } else {
      final baseSets = _currentExercise?.defaultSets ?? 4;
      final baseReps = _currentExercise?.defaultReps ?? 10;
      final baseWeight = _currentExercise?.defaultWeightKg ?? 40.0;
      _activeSets = List.generate(
        baseSets,
        (i) => WorkoutSet(
          setNumber: i + 1,
          reps: baseReps,
          weightKg: baseWeight,
          isCompleted: false,
        ),
      );
    }
  }

  void toggleSetCompletion(int index) {
    if (index >= 0 && index < _activeSets.length) {
      _activeSets[index].isCompleted = !_activeSets[index].isCompleted;
      if (_activeSets[index].isCompleted) {
        startRestTimer(45);
      }
      notifyListeners();
    }
  }

  void updateSetReps(int index, int reps) {
    if (index >= 0 && index < _activeSets.length) {
      _activeSets[index].reps = reps;
      notifyListeners();
    }
  }

  void updateSetWeight(int index, double weight) {
    if (index >= 0 && index < _activeSets.length) {
      _activeSets[index].weightKg = weight;
      notifyListeners();
    }
  }

  void addSet() {
    final nextNumber = _activeSets.length + 1;
    final lastWeight = _activeSets.isNotEmpty ? _activeSets.last.weightKg : 40.0;
    final lastReps = _activeSets.isNotEmpty ? _activeSets.last.reps : 10;
    _activeSets.add(WorkoutSet(
      setNumber: nextNumber,
      reps: lastReps,
      weightKg: lastWeight,
      isCompleted: false,
    ));
    notifyListeners();
  }

  void removeSet(int index) {
    if (_activeSets.length > 1 && index >= 0 && index < _activeSets.length) {
      _activeSets.removeAt(index);
      for (int i = 0; i < _activeSets.length; i++) {
        _activeSets[i] = _activeSets[i].copyWith(setNumber: i + 1);
      }
      notifyListeners();
    }
  }

  void startRestTimer([int duration = 45]) {
    _restTimer?.cancel();
    _restDurationTotal = duration;
    _restSecondsRemaining = duration;
    _isRestTimerRunning = true;
    notifyListeners();

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsRemaining > 0) {
        _restSecondsRemaining--;
        notifyListeners();
      } else {
        pauseRestTimer();
      }
    });
  }

  void togglePlayPauseRestTimer() {
    if (_isRestTimerRunning) {
      pauseRestTimer();
    } else {
      if (_restSecondsRemaining == 0) {
        _restSecondsRemaining = _restDurationTotal;
      }
      _isRestTimerRunning = true;
      notifyListeners();
      _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_restSecondsRemaining > 0) {
          _restSecondsRemaining--;
          notifyListeners();
        } else {
          pauseRestTimer();
        }
      });
    }
  }

  void pauseRestTimer() {
    _isRestTimerRunning = false;
    _restTimer?.cancel();
    notifyListeners();
  }

  void addRestSeconds(int seconds) {
    _restSecondsRemaining += seconds;
    _restDurationTotal += seconds;
    notifyListeners();
  }

  void resetRestTimer([int duration = 45]) {
    pauseRestTimer();
    _restSecondsRemaining = duration;
    _restDurationTotal = duration;
    notifyListeners();
  }

  WorkoutHistoryItem finishCurrentWorkout() {
    pauseRestTimer();
    final completedCount = _activeSets.where((s) => s.isCompleted).length;
    final totalReps = _activeSets.where((s) => s.isCompleted).fold(0, (sum, s) => sum + s.reps);
    final totalVol = _activeSets.where((s) => s.isCompleted).fold(0.0, (sum, s) => sum + (s.reps * s.weightKg));

    final historyItem = WorkoutHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseName: _currentExercise?.name ?? 'Workout',
      categoryName: _categories.firstWhere((c) => c.id == _currentExercise?.categoryId, orElse: () => _categories.first).name,
      completedSets: completedCount > 0 ? completedCount : _activeSets.length,
      totalReps: totalReps > 0 ? totalReps : 40,
      totalVolumeKg: totalVol > 0 ? totalVol : 1900.0,
      caloriesBurned: _currentExercise?.estimatedCalories ?? 180,
      durationMinutes: _currentExercise?.durationMinutes ?? 45,
      date: DateTime.now(),
    );

    _history.insert(0, historyItem);
    _storageService.saveWorkoutHistory(_history);
    notifyListeners();
    return historyItem;
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }
}
