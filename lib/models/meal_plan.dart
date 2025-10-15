class MealPlan {
  final String id;
  final DateTime date;
  final String recipeId;
  final String recipeTitle;
  final String mealType; // Breakfast, Lunch, Dinner
  final String? photoUrl;
  final String cuisineEmoji;

  MealPlan({
    required this.id,
    required this.date,
    required this.recipeId,
    required this.recipeTitle,
    required this.mealType,
    this.photoUrl,
    required this.cuisineEmoji,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'recipeId': recipeId,
      'recipeTitle': recipeTitle,
      'mealType': mealType,
      'photoUrl': photoUrl,
      'cuisineEmoji': cuisineEmoji,
    };
  }

  // Create from JSON
  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      date: DateTime.parse(json['date']),
      recipeId: json['recipeId'],
      recipeTitle: json['recipeTitle'],
      mealType: json['mealType'],
      photoUrl: json['photoUrl'],
      cuisineEmoji: json['cuisineEmoji'],
    );
  }

  MealPlan copyWith({
    String? id,
    DateTime? date,
    String? recipeId,
    String? recipeTitle,
    String? mealType,
    String? photoUrl,
    String? cuisineEmoji,
  }) {
    return MealPlan(
      id: id ?? this.id,
      date: date ?? this.date,
      recipeId: recipeId ?? this.recipeId,
      recipeTitle: recipeTitle ?? this.recipeTitle,
      mealType: mealType ?? this.mealType,
      photoUrl: photoUrl ?? this.photoUrl,
      cuisineEmoji: cuisineEmoji ?? this.cuisineEmoji,
    );
  }
}
