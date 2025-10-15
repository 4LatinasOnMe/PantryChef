class FoodDiaryEntry {
  final String id;
  final DateTime date;
  final String mealType; // Breakfast, Lunch, Dinner, Snack
  final String foodName;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String? recipeId; // Optional: link to recipe
  final String? notes;

  FoodDiaryEntry({
    required this.id,
    required this.date,
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.recipeId,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mealType': mealType,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'recipeId': recipeId,
      'notes': notes,
    };
  }

  factory FoodDiaryEntry.fromJson(Map<String, dynamic> json) {
    return FoodDiaryEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      mealType: json['mealType'],
      foodName: json['foodName'],
      calories: json['calories'],
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      recipeId: json['recipeId'],
      notes: json['notes'],
    );
  }
}

class DailySummary {
  final DateTime date;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final int calorieGoal;
  final List<FoodDiaryEntry> entries;

  DailySummary({
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.calorieGoal,
    required this.entries,
  });

  int get remainingCalories => calorieGoal - totalCalories;
  double get progress => (totalCalories / calorieGoal).clamp(0.0, 1.0);
  bool get goalMet => totalCalories >= calorieGoal;
  bool get overGoal => totalCalories > calorieGoal;
}
