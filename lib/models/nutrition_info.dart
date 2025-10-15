class NutritionInfo {
  final int calories;
  final double protein; // grams
  final double carbs; // grams
  final double fat; // grams
  final double fiber; // grams
  final int sodium; // mg
  final List<String> dietaryLabels; // e.g., "High Protein", "Low Carb"
  final List<String> allergens; // e.g., "Dairy", "Nuts"

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0,
    this.sodium = 0,
    this.dietaryLabels = const [],
    this.allergens = const [],
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sodium': sodium,
      'dietaryLabels': dietaryLabels,
      'allergens': allergens,
    };
  }

  // Create from JSON
  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      calories: json['calories'] ?? 0,
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      fiber: (json['fiber'] ?? 0).toDouble(),
      sodium: json['sodium'] ?? 0,
      dietaryLabels: List<String>.from(json['dietaryLabels'] ?? []),
      allergens: List<String>.from(json['allergens'] ?? []),
    );
  }

  // Calculate macros percentage
  int get proteinPercent => ((protein * 4) / calories * 100).round();
  int get carbsPercent => ((carbs * 4) / calories * 100).round();
  int get fatPercent => ((fat * 9) / calories * 100).round();

  // Health score (0-100)
  int get healthScore {
    int score = 50; // Base score
    
    // High protein is good
    if (protein > 20) score += 15;
    else if (protein > 10) score += 10;
    
    // Low sodium is good
    if (sodium < 500) score += 15;
    else if (sodium < 1000) score += 10;
    
    // High fiber is good
    if (fiber > 5) score += 10;
    else if (fiber > 3) score += 5;
    
    // Moderate fat is good
    if (fat < 15) score += 10;
    else if (fat < 25) score += 5;
    
    return score.clamp(0, 100);
  }
}
