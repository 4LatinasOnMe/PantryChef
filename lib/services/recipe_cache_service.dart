import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class RecipeCacheService {
  static const String _cacheKey = 'cached_recipes';
  static const String _lastFetchKey = 'last_fetch_time';
  static const Duration _cacheExpiry = Duration(days: 7);

  /// Save generated recipes to cache
  Future<void> cacheRecipes(List<Recipe> recipes, String ingredientsKey) async {
    final prefs = await SharedPreferences.getInstance();
    
    final cacheData = {
      'timestamp': DateTime.now().toIso8601String(),
      'ingredientsKey': ingredientsKey,
      'recipes': recipes.map((r) => r.toJson()).toList(),
    };
    
    await prefs.setString('$_cacheKey\_$ingredientsKey', jsonEncode(cacheData));
  }

  /// Get cached recipes for specific ingredients
  Future<List<Recipe>?> getCachedRecipes(String ingredientsKey) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheString = prefs.getString('$_cacheKey\_$ingredientsKey');
    
    if (cacheString == null) return null;
    
    try {
      final cacheData = jsonDecode(cacheString);
      final timestamp = DateTime.parse(cacheData['timestamp']);
      
      // Check if cache is expired
      if (DateTime.now().difference(timestamp) > _cacheExpiry) {
        return null;
      }
      
      final recipesJson = cacheData['recipes'] as List;
      return recipesJson.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('Error reading cache: $e');
      return null;
    }
  }

  /// Generate a cache key from ingredients
  String generateCacheKey(List<String> ingredients, {
    String? cuisineType,
    List<String>? dietaryNeeds,
    String? mealType,
  }) {
    final parts = [
      ingredients.join('_'),
      cuisineType ?? 'any',
      dietaryNeeds?.join('_') ?? 'none',
      mealType ?? 'any',
    ];
    return parts.join('__').toLowerCase().replaceAll(' ', '_');
  }

  /// Clear all cached recipes
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_cacheKey));
    for (var key in keys) {
      await prefs.remove(key);
    }
  }

  /// Get all cached recipe keys
  Future<List<String>> getCachedKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys()
        .where((key) => key.startsWith(_cacheKey))
        .toList();
  }
}
