import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition_info.dart';
import '../models/recipe.dart';
import '../config/api_config.dart';

class NutritionService {
  static String get _apiKey => ApiConfig.openAiApiKey;
  static String get _model => ApiConfig.openAiModel;
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  /// Estimate nutrition information for a recipe using AI
  Future<NutritionInfo?> estimateNutrition(Recipe recipe) async {
    if (_apiKey.isEmpty || _apiKey == 'your_openai_api_key_here') {
      return _getFallbackNutrition(recipe);
    }

    try {
      final prompt = _buildNutritionPrompt(recipe);
      
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a nutritionist. Estimate nutritional information for recipes. Always respond with valid JSON only.',
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.3,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        final nutritionJson = jsonDecode(content);
        
        return NutritionInfo(
          calories: nutritionJson['calories'] ?? 0,
          protein: (nutritionJson['protein'] ?? 0).toDouble(),
          carbs: (nutritionJson['carbs'] ?? 0).toDouble(),
          fat: (nutritionJson['fat'] ?? 0).toDouble(),
          fiber: (nutritionJson['fiber'] ?? 0).toDouble(),
          sodium: nutritionJson['sodium'] ?? 0,
          dietaryLabels: List<String>.from(nutritionJson['dietary_labels'] ?? []),
          allergens: List<String>.from(nutritionJson['allergens'] ?? []),
        );
      }
    } catch (e) {
      print('Error estimating nutrition: $e');
    }
    
    return _getFallbackNutrition(recipe);
  }

  String _buildNutritionPrompt(Recipe recipe) {
    final buffer = StringBuffer();
    buffer.writeln('Estimate nutritional information PER SERVING for this recipe:');
    buffer.writeln('');
    buffer.writeln('Recipe: ${recipe.title}');
    buffer.writeln('Servings: ${recipe.servings}');
    buffer.writeln('');
    buffer.writeln('Ingredients:');
    for (var ingredient in recipe.ingredients) {
      buffer.writeln('- $ingredient');
    }
    buffer.writeln('');
    buffer.writeln('Provide estimates in this exact JSON format:');
    buffer.writeln('''{
  "calories": 450,
  "protein": 25,
  "carbs": 35,
  "fat": 20,
  "fiber": 5,
  "sodium": 600,
  "dietary_labels": ["High Protein", "Low Carb"],
  "allergens": ["Dairy", "Gluten"]
}''');
    
    return buffer.toString();
  }

  /// Fallback nutrition estimation based on simple rules
  NutritionInfo _getFallbackNutrition(Recipe recipe) {
    // Simple estimation based on cuisine and ingredients
    int baseCalories = 400;
    double baseProtein = 20;
    double baseCarbs = 40;
    double baseFat = 15;
    
    final ingredientsText = recipe.ingredients.join(' ').toLowerCase();
    final List<String> labels = [];
    final List<String> allergens = [];
    
    // Adjust based on ingredients
    if (ingredientsText.contains('chicken') || ingredientsText.contains('beef') || 
        ingredientsText.contains('pork') || ingredientsText.contains('fish')) {
      baseProtein += 10;
      baseCalories += 50;
      labels.add('High Protein');
    }
    
    if (ingredientsText.contains('pasta') || ingredientsText.contains('rice') || 
        ingredientsText.contains('bread') || ingredientsText.contains('noodles')) {
      baseCarbs += 20;
      baseCalories += 100;
      allergens.add('Gluten');
    }
    
    if (ingredientsText.contains('cheese') || ingredientsText.contains('cream') || 
        ingredientsText.contains('butter') || ingredientsText.contains('milk')) {
      baseFat += 10;
      baseCalories += 80;
      allergens.add('Dairy');
    }
    
    if (ingredientsText.contains('oil') || ingredientsText.contains('avocado')) {
      baseFat += 15;
      baseCalories += 100;
    }
    
    if (ingredientsText.contains('vegetable') || ingredientsText.contains('salad') || 
        ingredientsText.contains('greens')) {
      labels.add('High Fiber');
      if (!labels.contains('High Protein')) {
        labels.add('Low Calorie');
      }
    }
    
    // Check dietary needs
    if (recipe.dietaryNeeds.contains('Low-Carb') || recipe.dietaryNeeds.contains('Keto')) {
      baseCarbs = (baseCarbs * 0.3).round().toDouble();
      baseFat = (baseFat * 1.5).round().toDouble();
      labels.add('Low Carb');
      labels.add('Keto Friendly');
    }
    
    if (recipe.dietaryNeeds.contains('Vegan') || recipe.dietaryNeeds.contains('Vegetarian')) {
      allergens.remove('Dairy');
      labels.add('Plant Based');
    }
    
    if (ingredientsText.contains('nuts') || ingredientsText.contains('almond') || 
        ingredientsText.contains('peanut')) {
      allergens.add('Nuts');
    }
    
    return NutritionInfo(
      calories: baseCalories,
      protein: baseProtein,
      carbs: baseCarbs,
      fat: baseFat,
      fiber: 5,
      sodium: 600,
      dietaryLabels: labels,
      allergens: allergens,
    );
  }
}
