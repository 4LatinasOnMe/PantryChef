import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../config/api_config.dart';

class RecipeVariationService {
  static String get _apiKey => ApiConfig.openAiApiKey;
  static String get _model => ApiConfig.openAiModel;
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  /// Generate a variation of an existing recipe
  Future<Recipe> generateVariation({
    required Recipe originalRecipe,
    required String variationType,
  }) async {
    if (_apiKey.isEmpty || _apiKey == 'your_openai_api_key_here') {
      throw Exception('OpenAI API key not configured.');
    }

    try {
      final prompt = _buildVariationPrompt(originalRecipe, variationType);
      
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
              'content': 'You are a professional chef. Modify recipes based on user requests. Always respond with valid JSON only.',
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        final recipeJson = jsonDecode(content);
        
        return Recipe(
          id: '${originalRecipe.id}_${variationType}_${DateTime.now().millisecondsSinceEpoch}',
          title: recipeJson['title'] ?? '${_getVariationPrefix(variationType)} ${originalRecipe.title}',
          description: recipeJson['description'] ?? originalRecipe.description,
          prepTime: recipeJson['prep_time'] ?? originalRecipe.prepTime,
          cookTime: recipeJson['cook_time'] ?? originalRecipe.cookTime,
          servings: recipeJson['servings'] ?? originalRecipe.servings,
          ingredients: List<String>.from(recipeJson['ingredients'] ?? originalRecipe.ingredients),
          instructions: List<String>.from(recipeJson['instructions'] ?? originalRecipe.instructions),
          cuisineType: originalRecipe.cuisineType,
          dietaryNeeds: _getDietaryNeeds(variationType, originalRecipe.dietaryNeeds),
          mealType: originalRecipe.mealType,
          createdAt: DateTime.now(),
          isSaved: false,
          photoUrl: originalRecipe.photoUrl, // Keep same photo
        );
      } else {
        throw Exception('Failed to generate variation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating variation: $e');
    }
  }

  String _buildVariationPrompt(Recipe recipe, String variationType) {
    final buffer = StringBuffer();
    buffer.writeln('Modify this recipe to be: $variationType');
    buffer.writeln('');
    buffer.writeln('Original Recipe: ${recipe.title}');
    buffer.writeln('Description: ${recipe.description}');
    buffer.writeln('');
    buffer.writeln('Ingredients:');
    for (var ingredient in recipe.ingredients) {
      buffer.writeln('- $ingredient');
    }
    buffer.writeln('');
    buffer.writeln('Instructions:');
    for (var i = 0; i < recipe.instructions.length; i++) {
      buffer.writeln('${i + 1}. ${recipe.instructions[i]}');
    }
    buffer.writeln('');
    buffer.writeln(_getVariationInstructions(variationType));
    buffer.writeln('');
    buffer.writeln('Respond with ONLY valid JSON in this exact format:');
    buffer.writeln('''{
  "title": "Modified Recipe Name",
  "description": "Brief description",
  "prep_time": 15,
  "cook_time": 30,
  "servings": 4,
  "ingredients": [
    "ingredient with measurement"
  ],
  "instructions": [
    "Step 1: instruction",
    "Step 2: instruction"
  ]
}''');
    
    return buffer.toString();
  }

  String _getVariationInstructions(String variationType) {
    switch (variationType.toLowerCase()) {
      case 'spicy':
        return 'Make it SPICY by adding chili peppers, hot sauce, cayenne, or other spicy ingredients. Adjust cooking method if needed.';
      case 'vegetarian':
        return 'Make it VEGETARIAN by removing all meat and seafood. Replace with plant-based proteins like beans, lentils, tofu, or mushrooms.';
      case 'healthier':
        return 'Make it HEALTHIER by reducing fat, calories, and sodium. Use Greek yogurt instead of cream, olive oil instead of butter, add more vegetables.';
      case 'vegan':
        return 'Make it VEGAN by removing all animal products (meat, dairy, eggs, honey). Use plant-based alternatives.';
      case 'gluten-free':
        return 'Make it GLUTEN-FREE by replacing wheat pasta/bread with gluten-free alternatives. Use rice, quinoa, or gluten-free flour.';
      case 'low-carb':
        return 'Make it LOW-CARB/KETO by reducing carbs and increasing healthy fats. Replace pasta/rice with cauliflower rice or zucchini noodles.';
      case 'quick':
        return 'Make it QUICKER by simplifying steps and reducing cooking time. Use shortcuts and pre-prepped ingredients.';
      default:
        return 'Modify the recipe as requested while keeping it delicious and practical.';
    }
  }

  String _getVariationPrefix(String variationType) {
    switch (variationType.toLowerCase()) {
      case 'spicy':
        return 'Spicy';
      case 'vegetarian':
        return 'Vegetarian';
      case 'healthier':
        return 'Healthy';
      case 'vegan':
        return 'Vegan';
      case 'gluten-free':
        return 'Gluten-Free';
      case 'low-carb':
        return 'Low-Carb';
      case 'quick':
        return 'Quick';
      default:
        return 'Modified';
    }
  }

  List<String> _getDietaryNeeds(String variationType, List<String> original) {
    final needs = List<String>.from(original);
    
    switch (variationType.toLowerCase()) {
      case 'vegetarian':
        if (!needs.contains('Vegetarian')) needs.add('Vegetarian');
        break;
      case 'vegan':
        if (!needs.contains('Vegan')) needs.add('Vegan');
        break;
      case 'gluten-free':
        if (!needs.contains('Gluten-Free')) needs.add('Gluten-Free');
        break;
      case 'low-carb':
        if (!needs.contains('Low-Carb')) needs.add('Low-Carb');
        break;
    }
    
    return needs;
  }
}
