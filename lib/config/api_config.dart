import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API Configuration
/// Keys are loaded from .env file for security
/// WARNING: These keys are still embedded in the APK and can be extracted.
/// For production, use a backend server to protect your keys.
class ApiConfig {
  // Load API keys from .env file
  static String get openAiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static String get openAiModel => dotenv.env['OPENAI_MODEL'] ?? 'gpt-4o-mini';
  static String get unsplashAccessKey => dotenv.env['UNSPLASH_ACCESS_KEY'] ?? '';
}
