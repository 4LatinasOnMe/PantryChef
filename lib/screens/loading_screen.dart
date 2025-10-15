import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/recipe_service.dart';
import 'recipe_selection_screen.dart';

class LoadingScreen extends StatefulWidget {
  final List<String> ingredients;
  final String? cuisineType;
  final List<String>? dietaryNeeds;
  final String? mealType;
  final String? cookingTime;
  final int recipeCount;
  final RecipeService recipeService;

  const LoadingScreen({
    super.key,
    required this.ingredients,
    this.cuisineType,
    this.dietaryNeeds,
    this.mealType,
    this.cookingTime,
    this.recipeCount = 4,
    required this.recipeService,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _currentTipIndex = 0;
  int _currentDot = 0;
  Timer? _tipTimer;
  Timer? _dotTimer;

  final List<String> _cookingTips = [
    '💡 Season your pasta water generously—it should taste like the sea!',
    '💡 Let meat rest after cooking to keep it juicy and tender.',
    '💡 Add a pinch of salt to bring out the sweetness in desserts.',
    '💡 Room temperature ingredients mix better in baking recipes.',
    '💡 Taste as you cook! Adjust seasoning throughout the process.',
    '💡 A sharp knife is safer than a dull one—and makes prep easier.',
    '💡 Don\'t overcrowd the pan—give ingredients space to brown properly.',
    '💡 Fresh herbs at the end, dried herbs at the beginning.',
    '💡 Save pasta water—it\'s liquid gold for finishing sauces!',
    '💡 Preheat your pan before adding oil for better results.',
    '💡 Acid (lemon, vinegar) brightens flavors—add a splash at the end!',
    '💡 Let baked goods cool completely before cutting for clean slices.',
  ];

  @override
  void initState() {
    super.initState();
    
    // Animation controller for chef hat bounce
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Rotate cooking tips every 4 seconds
    _tipTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _cookingTips.length;
        });
      }
    });

    // Animate progress dots
    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _currentDot = (_currentDot + 1) % 5;
        });
      }
    });

    // Generate recipe
    _generateRecipe();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tipTimer?.cancel();
    _dotTimer?.cancel();
    super.dispose();
  }

  Future<void> _generateRecipe() async {
    try {
      // Generate multiple recipes
      final recipes = await widget.recipeService.generateMultipleRecipes(
        ingredients: widget.ingredients,
        cuisineType: widget.cuisineType,
        dietaryNeeds: widget.dietaryNeeds,
        mealType: widget.mealType,
        cookingTime: widget.cookingTime,
        count: widget.recipeCount,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                RecipeSelectionScreen(recipes: recipes),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeOut;
              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating recipes: $e'),
            backgroundColor: AppColors.error,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark 
          ? const Color(0xFF121212) 
          : AppColors.background.withOpacity(0.98),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Chef Hat
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -10 * _animationController.value),
                    child: Transform.rotate(
                      angle: 0.1 * _animationController.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '👨‍🍳',
                      style: TextStyle(fontSize: 100),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Status Text
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.7, end: 1.0),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: Text(
                  'Creating your recipe options...',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Cooking Tip Card
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.l),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      offset: const Offset(0, 4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _cookingTips[_currentTipIndex],
                    key: ValueKey<int>(_currentTipIndex),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Progress Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index <= _currentDot
                          ? AppColors.accent
                          : AppColors.divider,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
