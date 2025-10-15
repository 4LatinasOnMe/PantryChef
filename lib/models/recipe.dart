class Recipe {
  final String id;
  final String title;
  final String description;
  final int prepTime; // in minutes
  final int cookTime; // in minutes
  final int servings;
  final List<String> ingredients;
  final List<String> instructions;
  final String cuisineType;
  final List<String> dietaryNeeds;
  final String mealType;
  final DateTime createdAt;
  bool isSaved;
  int rating; // 0-5 stars
  String notes; // User notes
  String? photoUrl; // Recipe photo URL
  Map<String, dynamic>? nutritionData; // Nutrition information

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    required this.cuisineType,
    required this.dietaryNeeds,
    required this.mealType,
    required this.createdAt,
    this.isSaved = false,
    this.rating = 0,
    this.notes = '',
    this.photoUrl,
    this.nutritionData,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'ingredients': ingredients,
      'instructions': instructions,
      'cuisineType': cuisineType,
      'dietaryNeeds': dietaryNeeds,
      'mealType': mealType,
      'createdAt': createdAt.toIso8601String(),
      'isSaved': isSaved,
      'rating': rating,
      'notes': notes,
      'photoUrl': photoUrl,
      'nutritionData': nutritionData,
    };
  }

  // Create from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      prepTime: json['prepTime'],
      cookTime: json['cookTime'],
      servings: json['servings'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      cuisineType: json['cuisineType'],
      dietaryNeeds: List<String>.from(json['dietaryNeeds']),
      mealType: json['mealType'],
      createdAt: DateTime.parse(json['createdAt']),
      isSaved: json['isSaved'] ?? false,
      rating: json['rating'] ?? 0,
      notes: json['notes'] ?? '',
      photoUrl: json['photoUrl'],
      nutritionData: json['nutritionData'],
    );
  }

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    int? prepTime,
    int? cookTime,
    int? servings,
    List<String>? ingredients,
    List<String>? instructions,
    String? cuisineType,
    List<String>? dietaryNeeds,
    String? mealType,
    DateTime? createdAt,
    bool? isSaved,
    int? rating,
    String? notes,
    String? photoUrl,
    Map<String, dynamic>? nutritionData,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      cuisineType: cuisineType ?? this.cuisineType,
      dietaryNeeds: dietaryNeeds ?? this.dietaryNeeds,
      mealType: mealType ?? this.mealType,
      createdAt: createdAt ?? this.createdAt,
      isSaved: isSaved ?? this.isSaved,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
      nutritionData: nutritionData ?? this.nutritionData,
    );
  }

  int get totalTime => prepTime + cookTime;
}
