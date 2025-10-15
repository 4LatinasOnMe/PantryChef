import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cookbook_screen_enhanced.dart';
import 'screens/shopping_list_screen.dart';
import 'screens/meal_planning_screen.dart';
import 'screens/food_diary_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const PantryChefApp(),
    ),
  );
}

class PantryChefApp extends StatefulWidget {
  const PantryChefApp({super.key});

  @override
  State<PantryChefApp> createState() => _PantryChefAppState();
}

class _PantryChefAppState extends State<PantryChefApp> {
  bool _showWelcome = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    
    if (mounted) {
      setState(() {
        _showWelcome = !onboardingComplete;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    if (_isLoading) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.themeMode,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    
    return MaterialApp(
      key: ValueKey(themeProvider.themeMode),
      title: 'PantryChef',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: _showWelcome ? const WelcomeScreen() : const HomeScreen(),
      routes: {
        '/cookbook': (context) => const CookbookScreenEnhanced(),
        '/shopping-list': (context) => const ShoppingListScreen(),
        '/meal-planning': (context) => const MealPlanningScreen(),
        '/food-diary': (context) => const FoodDiaryScreen(),
      },
    );
  }
}
