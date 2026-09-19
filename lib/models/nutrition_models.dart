import 'dart:convert';

class MealItem {
  final String id;
  final String title;
  final String subtitle;
  final int calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final String mealType; // 'Breakfast', 'Lunch', 'Dinner', 'Snacks'
  final String time;

  MealItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.calories,
    this.proteinGrams = 25.0,
    this.carbsGrams = 40.0,
    this.fatGrams = 12.0,
    required this.mealType,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbsGrams': carbsGrams,
      'fatGrams': fatGrams,
      'mealType': mealType,
      'time': time,
    };
  }

  factory MealItem.fromMap(Map<String, dynamic> map) {
    return MealItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      calories: map['calories'] ?? 0,
      proteinGrams: (map['proteinGrams'] as num?)?.toDouble() ?? 20.0,
      carbsGrams: (map['carbsGrams'] as num?)?.toDouble() ?? 30.0,
      fatGrams: (map['fatGrams'] as num?)?.toDouble() ?? 10.0,
      mealType: map['mealType'] ?? 'Breakfast',
      time: map['time'] ?? '08:00 AM',
    );
  }

  String toJson() => json.encode(toMap());
  factory MealItem.fromJson(String source) => MealItem.fromMap(json.decode(source));
}
