import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class UnsplashService {
  static String get _accessKey => ApiConfig.unsplashAccessKey;
  static const String _baseUrl = 'https://api.unsplash.com';
  static const String _placeholderBaseUrl = 'https://source.unsplash.com';

  /// Search for food photos based on query
  Future<String?> searchFoodPhoto(String query) async {
    // If no API key, use placeholder
    if (_accessKey.isEmpty) {
      final searchTerms = query.toLowerCase().replaceAll(' ', ',');
      final url = '$_placeholderBaseUrl/800x600/?food,$searchTerms';
      print('Using placeholder photo: $url');
      return url;
    }

    try {
      // Build search query with food context
      final searchQuery = '$query food dish meal';
      
      final url = Uri.parse(
        '$_baseUrl/search/photos?query=$searchQuery&per_page=1&orientation=landscape',
      );

      final response = await http.get(
        url,
        headers: {
          'Accept-Version': 'v1',
          'Authorization': 'Client-ID $_accessKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        
        if (results.isNotEmpty) {
          final photo = results[0];
          final photoUrl = photo['urls']['regular'] as String?;
          print('Found Unsplash photo: $photoUrl');
          return photoUrl;
        }
      } else {
        print('Unsplash API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Unsplash photo: $e');
    }
    
    // Fallback to placeholder
    final searchTerms = query.toLowerCase().replaceAll(' ', ',');
    return '$_placeholderBaseUrl/800x600/?food,$searchTerms';
  }

  /// Get a random food photo based on cuisine
  Future<String?> getRandomFoodPhoto(String cuisine) async {
    try {
      final searchTerms = cuisine.toLowerCase();
      final url = '$_placeholderBaseUrl/800x600/?food,$searchTerms,cuisine';
      
      print('Fetching random photo from: $url');
      return url;
    } catch (e) {
      print('Error fetching random Unsplash photo: $e');
    }
    
    return null;
  }

  /// Get photo URL for a specific recipe
  Future<String?> getRecipePhoto({
    required String recipeName,
    required String cuisine,
  }) async {
    // Try searching with recipe name first
    String? photoUrl = await searchFoodPhoto('$recipeName $cuisine');
    
    // If no result, try just cuisine
    if (photoUrl == null) {
      photoUrl = await getRandomFoodPhoto(cuisine);
    }
    
    // If still no result, try generic food
    if (photoUrl == null) {
      photoUrl = await searchFoodPhoto('delicious food');
    }
    
    return photoUrl;
  }

  /// Get fallback placeholder based on cuisine
  String getFallbackEmoji(String cuisine) {
    final emojiMap = {
      'Italian': '🍝',
      'Asian': '🍜',
      'Mexican': '🌮',
      'American': '🍔',
      'Mediterranean': '🥗',
      'Indian': '🍛',
      'French': '🥐',
      'Thai': '🍲',
      'Chinese': '🥡',
      'Japanese': '🍱',
    };
    
    return emojiMap[cuisine] ?? '🍽️';
  }
}
