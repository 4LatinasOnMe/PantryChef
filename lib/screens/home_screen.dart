import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import '../services/recipe_service.dart';
import '../services/shopping_list_service.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ingredientsController = TextEditingController();
  final RecipeService _recipeService = RecipeService();
  final ShoppingListService _shoppingListService = ShoppingListService();
  
  final Set<String> _selectedCuisines = {};
  final Set<String> _selectedDietary = {};
  final Set<String> _selectedMealTypes = {};
  String? _selectedCookingTime;
  String _selectedRecipeCount = '4 recipes';
  int _shoppingListCount = 0;

  final List<String> _cuisineTypes = [
    'Italian',
    'Asian',
    'Mexican',
    'American',
    'Mediterranean',
    'Indian',
    'French',
    'Thai',
  ];

  final List<String> _dietaryNeeds = [
    'Vegan',
    'Vegetarian',
    'Gluten-Free',
    'Dairy-Free',
    'Low-Carb',
    'Keto',
    'Paleo',
    'Nut-Free',
  ];

  final List<String> _mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Dessert',
    'Appetizer',
  ];

  final Map<String, String> _cookingTimeOptions = {
    '15 min or less': '15',
    '30 min or less': '30',
    '45 min or less': '45',
    '1 hour or less': '60',
    'More than 1 hour': '90',
    'Any time': 'any',
  };

  final List<String> _recipeCountOptions = [
    '3 recipes',
    '4 recipes',
    '5 recipes',
    '6 recipes',
    '8 recipes',
    '10 recipes',
  ];

  bool get _canGenerate => _ingredientsController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadShoppingListCount();
  }

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _loadShoppingListCount() async {
    final count = await _shoppingListService.getItemCount();
    if (mounted) {
      setState(() {
        _shoppingListCount = count;
      });
    }
  }

  void _generateRecipe() {
    if (!_canGenerate) return;

    final ingredients = _ingredientsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Parse recipe count from selected option (e.g., "4 recipes" -> 4)
    final recipeCount = int.parse(_selectedRecipeCount.split(' ')[0]);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          ingredients: ingredients,
          cuisineType: _selectedCuisines.isEmpty ? null : _selectedCuisines.join(' & '),
          dietaryNeeds: _selectedDietary.toList(),
          mealType: _selectedMealTypes.isEmpty ? null : _selectedMealTypes.join(' or '),
          cookingTime: _selectedCookingTime != null ? _cookingTimeOptions[_selectedCookingTime] : null,
          recipeCount: recipeCount,
          recipeService: _recipeService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🍳', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              'PantryChef',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ],
        ),
        actions: [
          // Theme Toggle
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            tooltip: 'Toggle Theme',
          ),
          // Shopping List with Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/shopping-list');
                  _loadShoppingListCount();
                },
                tooltip: 'Shopping List',
              ),
              if (_shoppingListCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      _shoppingListCount > 99 ? '99+' : '$_shoppingListCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // Menu Dropdown
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu',
            onSelected: (value) {
              switch (value) {
                case 'food_diary':
                  Navigator.pushNamed(context, '/food-diary');
                  break;
                case 'meal_planning':
                  Navigator.pushNamed(context, '/meal-planning');
                  break;
                case 'cookbook':
                  Navigator.pushNamed(context, '/cookbook');
                  break;
                case 'help':
                  _showHelpDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'food_diary',
                child: Row(
                  children: [
                    Icon(Icons.restaurant, size: 20),
                    SizedBox(width: 12),
                    Text('Food Diary'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'meal_planning',
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 20),
                    SizedBox(width: 12),
                    Text('Meal Planning'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'cookbook',
                child: Row(
                  children: [
                    Icon(Icons.book, size: 20),
                    SizedBox(width: 12),
                    Text('My Cookbook'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Help & Tutorial'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xl),
            
            // Welcome Header
            Text(
              'What\'s in your pantry?',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tell me what you have, and I\'ll create something delicious!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: AppSpacing.l),
            
            // Ingredient Input
            TextField(
              controller: _ingredientsController,
              maxLines: null,
              minLines: 5,
              decoration: const InputDecoration(
                hintText: 'e.g., chicken breast, tomatoes, pasta, garlic, olive oil...',
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Separate ingredients with commas',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Cuisine Type
            _buildSectionHeader('Cuisine Type'),
            _buildMultiSelectChipGroup(
              items: _cuisineTypes,
              selectedItems: _selectedCuisines,
              onSelected: (cuisine) {
                setState(() {
                  if (_selectedCuisines.contains(cuisine)) {
                    _selectedCuisines.remove(cuisine);
                  } else {
                    _selectedCuisines.add(cuisine);
                  }
                });
              },
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Dietary Needs
            _buildSectionHeader('Dietary Needs'),
            _buildMultiSelectChipGroup(
              items: _dietaryNeeds,
              selectedItems: _selectedDietary,
              onSelected: (dietary) {
                setState(() {
                  if (_selectedDietary.contains(dietary)) {
                    _selectedDietary.remove(dietary);
                  } else {
                    _selectedDietary.add(dietary);
                  }
                });
              },
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Meal Type
            _buildSectionHeader('Meal Type'),
            _buildMultiSelectChipGroup(
              items: _mealTypes,
              selectedItems: _selectedMealTypes,
              onSelected: (meal) {
                setState(() {
                  if (_selectedMealTypes.contains(meal)) {
                    _selectedMealTypes.remove(meal);
                  } else {
                    _selectedMealTypes.add(meal);
                  }
                });
              },
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Cooking Time
            _buildSectionHeader('How much time do you have? ⏱️'),
            _buildChipGroup(
              items: _cookingTimeOptions.keys.toList(),
              selectedItem: _selectedCookingTime,
              onSelected: (time) {
                setState(() {
                  _selectedCookingTime = time;
                });
              },
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Recipe Count Preference
            _buildSectionHeader('How many recipe options? 📋'),
            _buildChipGroup(
              items: _recipeCountOptions,
              selectedItem: _selectedRecipeCount,
              onSelected: (count) {
                setState(() {
                  _selectedRecipeCount = count;
                });
              },
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Generate Button
            ElevatedButton(
              onPressed: _canGenerate ? _generateRecipe : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canGenerate ? AppColors.accent : AppColors.divider,
                foregroundColor: _canGenerate ? Colors.white : AppColors.textTertiary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Generate ${_selectedRecipeCount.split(' ')[0]} Recipes',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(width: 8),
                  const Text('🔥', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildChipGroup({
    required List<String> items,
    required String? selectedItem,
    required Function(String) onSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: items.map((item) {
        final isSelected = selectedItem == item;
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (_) => onSelected(item),
          showCheckmark: true,
          checkmarkColor: Colors.white,
          backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          selectedColor: AppColors.accent,
          labelStyle: TextStyle(
            color: isSelected 
                ? Colors.white 
                : (isDark ? Colors.white : AppColors.textPrimary),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          side: isSelected
              ? BorderSide.none
              : BorderSide(
                  color: isDark ? const Color(0xFF4C4C4C) : AppColors.divider, 
                  width: 1.5,
                ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: 12,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          labelPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: AppColors.accent),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'How to Use PantryChef',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
              _buildHelpItem(
                '1️⃣ Generate Recipes',
                'Enter your ingredients, select preferences, and tap "Generate Recipe" to get AI-powered recipes!',
              ),
              _buildHelpItem(
                '2️⃣ Save to Cookbook',
                'Tap the bookmark icon on any recipe to save it to your cookbook for later.',
              ),
              _buildHelpItem(
                '3️⃣ Plan Your Week',
                'Use Meal Planning to schedule recipes for the week, then generate a shopping list!',
              ),
              _buildHelpItem(
                '4️⃣ Track Your Diet',
                'Log meals in Food Diary to track calories and macros throughout the day.',
              ),
              _buildHelpItem(
                '5️⃣ Recipe Variations',
                'On any recipe, tap variation chips (Spicy, Vegetarian, etc.) to create modified versions!',
              ),
              _buildHelpItem(
                '6️⃣ Shopping List',
                'Add ingredients from recipes to your shopping list and check them off while shopping.',
              ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectChipGroup({
    required List<String> items,
    required Set<String> selectedItems,
    required Function(String) onSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (_) => onSelected(item),
          showCheckmark: true,
          checkmarkColor: Colors.white,
          backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          selectedColor: AppColors.accent,
          labelStyle: TextStyle(
            color: isSelected 
                ? Colors.white 
                : (isDark ? Colors.white : AppColors.textPrimary),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          side: isSelected
              ? BorderSide.none
              : BorderSide(
                  color: isDark ? const Color(0xFF4C4C4C) : AppColors.divider, 
                  width: 1.5,
                ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: 12,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          labelPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}
