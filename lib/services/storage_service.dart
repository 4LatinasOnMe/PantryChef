import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class StorageService {
  static const String _savedRecipesKey = 'saved_recipes';
  static const String _checkedIngredientsKey = 'checked_ingredients_';

  // Save a recipe
  Future<void> saveRecipe(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final savedRecipes = await getSavedRecipes();
    
    // Add or update recipe
    savedRecipes.removeWhere((r) => r.id == recipe.id);
    savedRecipes.add(recipe.copyWith(isSaved: true));
    
    // Save to storage
    final jsonList = savedRecipes.map((r) => r.toJson()).toList();
    await prefs.setString(_savedRecipesKey, jsonEncode(jsonList));
  }

  // Remove a recipe
  Future<void> removeRecipe(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedRecipes = await getSavedRecipes();
    
    savedRecipes.removeWhere((r) => r.id == recipeId);
    
    final jsonList = savedRecipes.map((r) => r.toJson()).toList();
    await prefs.setString(_savedRecipesKey, jsonEncode(jsonList));
  }

  // Get all saved recipes
  Future<List<Recipe>> getSavedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_savedRecipesKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Recipe.fromJson(json)).toList();
  }

  // Check if recipe is saved
  Future<bool> isRecipeSaved(String recipeId) async {
    final savedRecipes = await getSavedRecipes();
    return savedRecipes.any((r) => r.id == recipeId);
  }

  // Save checked ingredients for a recipe
  Future<void> saveCheckedIngredients(String recipeId, List<int> checkedIndices) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_checkedIngredientsKey$recipeId',
      jsonEncode(checkedIndices),
    );
  }

  // Get checked ingredients for a recipe
  Future<List<int>> getCheckedIngredients(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$_checkedIngredientsKey$recipeId');
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<int>();
  }

  // Clear all checked ingredients for a recipe
  Future<void> clearCheckedIngredients(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_checkedIngredientsKey$recipeId');
  }
}
