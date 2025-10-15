class ShoppingListItem {
  final String id;
  final String ingredient;
  final String recipeId;
  final String recipeTitle;
  bool isChecked;

  ShoppingListItem({
    required this.id,
    required this.ingredient,
    required this.recipeId,
    required this.recipeTitle,
    this.isChecked = false,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingredient': ingredient,
      'recipeId': recipeId,
      'recipeTitle': recipeTitle,
      'isChecked': isChecked,
    };
  }

  // Create from JSON
  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'],
      ingredient: json['ingredient'],
      recipeId: json['recipeId'],
      recipeTitle: json['recipeTitle'],
      isChecked: json['isChecked'] ?? false,
    );
  }

  ShoppingListItem copyWith({
    String? id,
    String? ingredient,
    String? recipeId,
    String? recipeTitle,
    bool? isChecked,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      ingredient: ingredient ?? this.ingredient,
      recipeId: recipeId ?? this.recipeId,
      recipeTitle: recipeTitle ?? this.recipeTitle,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
