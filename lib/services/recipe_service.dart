import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../config/api_config.dart';

class RecipeService {
  static String get _apiKey => ApiConfig.openAiApiKey;
  static String get _model => ApiConfig.openAiModel;
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<List<Recipe>> generateMultipleRecipes({
    required List<String> ingredients,
    String? cuisineType,
    List<String>? dietaryNeeds,
    String? mealType,
    String? cookingTime,
    int count = 4,
  }) async {
    print('API Key length: ${_apiKey.length}');
    print('API Key starts with: ${_apiKey.substring(0, 10)}...');
    
    if (_apiKey.isEmpty || _apiKey == 'YOUR_OPENAI_API_KEY_HERE') {
      throw Exception('OpenAI API key not configured. Please add your API key to the config file.');
    }

    try {
      final prompt = _buildMultipleRecipesPrompt(ingredients, cuisineType, dietaryNeeds, mealType, cookingTime, count);
      
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
              'content': 'You are a professional chef and recipe creator. Generate creative, diverse, delicious recipes based on available ingredients. Always respond with valid JSON only, no additional text.',
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.9,
          'max_tokens': 4000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // Parse the recipes JSON from the response
        final recipesJson = jsonDecode(content);
        final recipesList = recipesJson['recipes'] as List;
        
        return recipesList.asMap().entries.map((entry) {
          final index = entry.key;
          final recipeJson = entry.value;
          
          return Recipe(
            id: '${DateTime.now().millisecondsSinceEpoch}_$index',
            title: recipeJson['title'] ?? 'Delicious Recipe',
            description: recipeJson['description'] ?? 'A wonderful homemade dish',
            prepTime: recipeJson['prep_time'] ?? 15,
            cookTime: recipeJson['cook_time'] ?? 30,
            servings: recipeJson['servings'] ?? 4,
            ingredients: List<String>.from(recipeJson['ingredients'] ?? []),
            instructions: List<String>.from(recipeJson['instructions'] ?? []),
            cuisineType: cuisineType ?? 'Any',
            dietaryNeeds: dietaryNeeds ?? [],
            mealType: mealType ?? 'Dinner',
            createdAt: DateTime.now(),
            isSaved: false,
          );
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your OpenAI API key in the .env file.');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again in a moment.');
      } else {
        print('API Error Response: ${response.body}');
        throw Exception('Failed to generate recipes: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Recipe generation error: $e');
      print('Error type: ${e.runtimeType}');
      
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Cannot connect to OpenAI. Check internet connection.');
      } else if (e.toString().contains('HandshakeException') || e.toString().contains('CERTIFICATE')) {
        throw Exception('SSL error: Cannot verify OpenAI certificate. Try updating your phone.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout: OpenAI took too long to respond.');
      }
      
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<Recipe> generateRecipe({
    required List<String> ingredients,
    String? cuisineType,
    List<String>? dietaryNeeds,
    String? mealType,
  }) async {
    print('API Key length: ${_apiKey.length}');
    print('API Key starts with: ${_apiKey.substring(0, 10)}...');
    
    if (_apiKey.isEmpty || _apiKey == 'YOUR_OPENAI_API_KEY_HERE') {
      throw Exception('OpenAI API key not configured. Please add your API key to the config file.');
    }

    try {
      final prompt = _buildPrompt(ingredients, cuisineType, dietaryNeeds, mealType);
      
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
              'content': 'You are a professional chef and recipe creator. Generate creative, delicious recipes based on available ingredients. Always respond with valid JSON only, no additional text.',
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.8,
          'max_tokens': 1500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // Parse the recipe JSON from the response
        final recipeJson = jsonDecode(content);
        
        return Recipe(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: recipeJson['title'] ?? 'Delicious Recipe',
          description: recipeJson['description'] ?? 'A wonderful homemade dish',
          prepTime: recipeJson['prep_time'] ?? 15,
          cookTime: recipeJson['cook_time'] ?? 30,
          servings: recipeJson['servings'] ?? 4,
          ingredients: List<String>.from(recipeJson['ingredients'] ?? []),
          instructions: List<String>.from(recipeJson['instructions'] ?? []),
          cuisineType: cuisineType ?? 'Any',
          dietaryNeeds: dietaryNeeds ?? [],
          mealType: mealType ?? 'Dinner',
          createdAt: DateTime.now(),
          isSaved: false,
        );
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your OpenAI API key in the .env file.');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again in a moment.');
      } else {
        print('API Error Response: ${response.body}');
        throw Exception('Failed to generate recipe: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Recipe generation error: $e');
      print('Error type: ${e.runtimeType}');
      
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Cannot connect to OpenAI. Check internet connection.');
      } else if (e.toString().contains('HandshakeException') || e.toString().contains('CERTIFICATE')) {
        throw Exception('SSL error: Cannot verify OpenAI certificate. Try updating your phone.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout: OpenAI took too long to respond.');
      }
      
      throw Exception('Error: ${e.toString()}');
    }
  }

  String _buildMultipleRecipesPrompt(
    List<String> ingredients,
    String? cuisineType,
    List<String>? dietaryNeeds,
    String? mealType,
    String? cookingTime,
    int count,
  ) {
    final buffer = StringBuffer();
    buffer.writeln('Create $count diverse and creative recipes using these ingredients: ${ingredients.join(', ')}');
    buffer.writeln('\nMake each recipe UNIQUE and DIFFERENT from each other (different cooking methods, flavors, or styles).');
    
    if (cuisineType != null && cuisineType.isNotEmpty) {
      buffer.writeln('Cuisine style preference: $cuisineType');
    }
    
    if (dietaryNeeds != null && dietaryNeeds.isNotEmpty) {
      buffer.writeln('Dietary requirements: ${dietaryNeeds.join(', ')}');
    }
    
    if (mealType != null && mealType.isNotEmpty) {
      buffer.writeln('Meal type: $mealType');
    }
    
    if (cookingTime != null && cookingTime != 'any') {
      buffer.writeln('IMPORTANT: Total cooking time (prep + cook) must be $cookingTime minutes or less');
    }
    
    buffer.writeln('\nIMPORTANT: Respond with ONLY valid JSON in this exact format:');
    buffer.writeln('''{
  "recipes": [
    {
      "title": "Recipe Name 1",
      "description": "Brief appetizing description (1-2 sentences)",
      "prep_time": 15,
      "cook_time": 30,
      "servings": 4,
      "ingredients": [
        "2 cups ingredient with measurement",
        "1 lb another ingredient with measurement"
      ],
      "instructions": [
        "Step 1: Detailed first instruction",
        "Step 2: Detailed second instruction"
      ]
    },
    {
      "title": "Recipe Name 2",
      "description": "Brief appetizing description (1-2 sentences)",
      "prep_time": 20,
      "cook_time": 25,
      "servings": 4,
      "ingredients": [
        "ingredient list"
      ],
      "instructions": [
        "instruction steps"
      ]
    }
  ]
}''');
    
    return buffer.toString();
  }

  String _buildPrompt(
    List<String> ingredients,
    String? cuisineType,
    List<String>? dietaryNeeds,
    String? mealType,
  ) {
    final buffer = StringBuffer();
    buffer.writeln('Create a delicious recipe using these ingredients: ${ingredients.join(', ')}');
    
    if (cuisineType != null && cuisineType.isNotEmpty) {
      buffer.writeln('Cuisine style: $cuisineType');
    }
    
    if (dietaryNeeds != null && dietaryNeeds.isNotEmpty) {
      buffer.writeln('Dietary requirements: ${dietaryNeeds.join(', ')}');
    }
    
    if (mealType != null && mealType.isNotEmpty) {
      buffer.writeln('Meal type: $mealType');
    }
    
    buffer.writeln('\nIMPORTANT: Respond with ONLY valid JSON in this exact format:');
    buffer.writeln('''{
  "title": "Recipe Name",
  "description": "Brief appetizing description (1-2 sentences)",
  "prep_time": 15,
  "cook_time": 30,
  "servings": 4,
  "ingredients": [
    "2 cups ingredient with measurement",
    "1 lb another ingredient with measurement"
  ],
  "instructions": [
    "Step 1: Detailed first instruction",
    "Step 2: Detailed second instruction"
  ]
}''');
    
    return buffer.toString();
  }
}
