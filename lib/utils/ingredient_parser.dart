class IngredientParser {
  /// Parse ingredient string to extract quantity, unit, and name
  static ParsedIngredient parse(String ingredient) {
    final trimmed = ingredient.trim();
    
    // Common units to detect
    final units = [
      'cup', 'cups', 'tablespoon', 'tablespoons', 'tbsp', 'teaspoon', 'teaspoons', 'tsp',
      'pound', 'pounds', 'lb', 'lbs', 'ounce', 'ounces', 'oz', 'gram', 'grams', 'g',
      'kilogram', 'kilograms', 'kg', 'milliliter', 'milliliters', 'ml', 'liter', 'liters', 'l',
      'piece', 'pieces', 'slice', 'slices', 'clove', 'cloves', 'can', 'cans',
      'package', 'packages', 'bunch', 'bunches', 'pinch', 'pinches', 'dash', 'dashes',
    ];
    
    // Try to match pattern: "number unit ingredient"
    final pattern = RegExp(r'^(\d+(?:[./]\d+)?)\s*([a-zA-Z]+)?\s+(.+)$');
    final match = pattern.firstMatch(trimmed);
    
    if (match != null) {
      final quantityStr = match.group(1)!;
      final unit = match.group(2)?.toLowerCase();
      final name = match.group(3)!;
      
      // Parse quantity (handle fractions like 1/2)
      double quantity;
      if (quantityStr.contains('/')) {
        final parts = quantityStr.split('/');
        quantity = double.parse(parts[0]) / double.parse(parts[1]);
      } else {
        quantity = double.parse(quantityStr);
      }
      
      // Verify unit is valid
      final validUnit = unit != null && units.contains(unit) ? unit : null;
      
      return ParsedIngredient(
        quantity: quantity,
        unit: validUnit,
        name: validUnit != null ? name : (unit != null ? '$unit $name' : name),
        original: ingredient,
      );
    }
    
    // If no quantity found, treat as whole ingredient
    return ParsedIngredient(
      quantity: null,
      unit: null,
      name: trimmed,
      original: ingredient,
    );
  }

  /// Combine ingredients with same name and unit
  static List<ParsedIngredient> combineIngredients(List<ParsedIngredient> ingredients) {
    final Map<String, ParsedIngredient> combined = {};
    
    for (var ingredient in ingredients) {
      final key = '${ingredient.name.toLowerCase()}_${ingredient.unit ?? 'none'}';
      
      if (combined.containsKey(key)) {
        // Combine quantities
        final existing = combined[key]!;
        if (existing.quantity != null && ingredient.quantity != null) {
          combined[key] = ParsedIngredient(
            quantity: existing.quantity! + ingredient.quantity!,
            unit: existing.unit,
            name: existing.name,
            original: existing.original,
            sources: [...existing.sources, ...ingredient.sources],
          );
        }
      } else {
        combined[key] = ingredient;
      }
    }
    
    return combined.values.toList();
  }

  /// Format ingredient for display
  static String format(ParsedIngredient ingredient) {
    final parts = <String>[];
    
    if (ingredient.quantity != null) {
      // Format quantity nicely
      if (ingredient.quantity! % 1 == 0) {
        parts.add(ingredient.quantity!.toInt().toString());
      } else {
        // Convert to fraction if possible
        final fraction = _toFraction(ingredient.quantity!);
        parts.add(fraction ?? ingredient.quantity!.toStringAsFixed(2));
      }
    }
    
    if (ingredient.unit != null) {
      parts.add(ingredient.unit!);
    }
    
    parts.add(ingredient.name);
    
    return parts.join(' ');
  }

  static String? _toFraction(double value) {
    // Common fractions
    final fractions = {
      0.25: '1/4',
      0.33: '1/3',
      0.5: '1/2',
      0.66: '2/3',
      0.75: '3/4',
      1.5: '1 1/2',
      2.5: '2 1/2',
    };
    
    for (var entry in fractions.entries) {
      if ((value - entry.key).abs() < 0.01) {
        return entry.value;
      }
    }
    
    return null;
  }
}

class ParsedIngredient {
  final double? quantity;
  final String? unit;
  final String name;
  final String original;
  final List<String> sources;

  ParsedIngredient({
    this.quantity,
    this.unit,
    required this.name,
    required this.original,
    List<String>? sources,
  }) : sources = sources ?? [];

  ParsedIngredient copyWith({
    double? quantity,
    String? unit,
    String? name,
    String? original,
    List<String>? sources,
  }) {
    return ParsedIngredient(
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      name: name ?? this.name,
      original: original ?? this.original,
      sources: sources ?? this.sources,
    );
  }
}
