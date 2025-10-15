import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';
import '../services/meal_plan_service.dart';
import '../services/storage_service.dart';
import '../services/shopping_list_service.dart';
import '../models/shopping_list_item.dart';
import 'recipe_screen_enhanced.dart';

class MealPlanningScreen extends StatefulWidget {
  const MealPlanningScreen({super.key});

  @override
  State<MealPlanningScreen> createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<MealPlanningScreen> {
  final MealPlanService _mealPlanService = MealPlanService();
  final StorageService _storageService = StorageService();
  final ShoppingListService _shoppingListService = ShoppingListService();
  
  late DateTime _weekStart;
  Map<DateTime, List<MealPlan>> _weekPlans = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _weekStart = _getWeekStart(DateTime.now());
    _loadWeekPlans();
  }

  DateTime _getWeekStart(DateTime date) {
    // Get Monday of the current week
    return date.subtract(Duration(days: date.weekday - 1));
  }

  Future<void> _loadWeekPlans() async {
    final plans = await _mealPlanService.getMealPlansForWeek(_weekStart);
    if (mounted) {
      setState(() {
        _weekPlans = plans;
        _isLoading = false;
      });
    }
  }

  void _previousWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
      _isLoading = true;
    });
    _loadWeekPlans();
  }

  void _nextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
      _isLoading = true;
    });
    _loadWeekPlans();
  }

  void _goToToday() {
    setState(() {
      _weekStart = _getWeekStart(DateTime.now());
      _isLoading = true;
    });
    _loadWeekPlans();
  }

  Future<void> _addMealToDay(DateTime date) async {
    final recipes = await _storageService.getSavedRecipes();
    
    if (recipes.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No saved recipes. Save some recipes first!'),
          ),
        );
      }
      return;
    }

    if (!mounted) return;
    
    final selectedRecipe = await showDialog<Recipe>(
      context: context,
      builder: (context) => _RecipePickerDialog(recipes: recipes),
    );

    if (selectedRecipe != null) {
      final mealPlan = MealPlan(
        id: '${date.millisecondsSinceEpoch}_${selectedRecipe.id}',
        date: date,
        recipeId: selectedRecipe.id,
        recipeTitle: selectedRecipe.title,
        mealType: selectedRecipe.mealType,
        photoUrl: selectedRecipe.photoUrl,
        cuisineEmoji: _getCuisineEmoji(selectedRecipe.cuisineType),
      );

      await _mealPlanService.addMealPlan(mealPlan);
      await _loadWeekPlans();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${selectedRecipe.title} added to ${_formatDate(date)}')),
        );
      }
    }
  }

  Future<void> _removeMeal(MealPlan mealPlan) async {
    await _mealPlanService.removeMealPlan(mealPlan.id);
    await _loadWeekPlans();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal removed')),
      );
    }
  }

  Future<void> _generateWeeklyShoppingList() async {
    final allRecipes = await _storageService.getSavedRecipes();
    final List<ShoppingListItem> items = [];
    
    for (var dayPlans in _weekPlans.values) {
      for (var mealPlan in dayPlans) {
        final recipe = allRecipes.firstWhere(
          (r) => r.id == mealPlan.recipeId,
          orElse: () => allRecipes.first,
        );
        
        for (var ingredient in recipe.ingredients) {
          items.add(ShoppingListItem(
            id: '${mealPlan.id}_${ingredient.hashCode}',
            ingredient: ingredient,
            recipeId: recipe.id,
            recipeTitle: recipe.title,
          ));
        }
      }
    }

    if (items.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No meals planned this week')),
        );
      }
      return;
    }

    await _shoppingListService.addItems(items);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${items.length} ingredients added to shopping list'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              Navigator.pushNamed(context, '/shopping-list');
            },
          ),
        ),
      );
    }
  }

  String _getCuisineEmoji(String cuisine) {
    final emojiMap = {
      'Italian': '🍝',
      'Asian': '🍜',
      'Mexican': '🌮',
      'American': '🍔',
      'Mediterranean': '🥗',
      'Indian': '🍛',
      'French': '🥐',
      'Thai': '🍲',
    };
    return emojiMap[cuisine] ?? '🍽️';
  }

  String _formatDate(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planning'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _goToToday,
            tooltip: 'Go to today',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Week Navigation
                Container(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1E1E1E)
                      : AppColors.background,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _previousWeek,
                      ),
                      Expanded(
                        child: Text(
                          _getWeekRange(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _nextWeek,
                      ),
                    ],
                  ),
                ),

                // Calendar Grid
                Expanded(
                  child: ListView.builder(
                    padding: AppSpacing.screen,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      final date = _weekStart.add(Duration(days: index));
                      final dateKey = DateTime(date.year, date.month, date.day);
                      final dayPlans = _weekPlans[dateKey] ?? [];
                      final isToday = _isToday(date);

                      return _buildDayCard(date, dayPlans, isToday);
                    },
                  ),
                ),

                // Generate Shopping List Button
                Container(
                  padding: AppSpacing.screen,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF1E1E1E)
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.05,
                        ),
                        offset: const Offset(0, -2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _generateWeeklyShoppingList,
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Generate Weekly Shopping List'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDayCard(DateTime date, List<MealPlan> dayPlans, bool isToday) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: isToday
            ? Border.all(color: AppColors.accent, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.accent.withOpacity(0.1)
                  : (isDark ? const Color(0xFF1E1E1E) : AppColors.background),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.m),
                topRight: Radius.circular(AppRadius.m),
              ),
            ),
            child: Row(
              children: [
                Text(
                  _formatDate(date),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isToday 
                        ? AppColors.accent 
                        : (isDark ? Colors.white : AppColors.textPrimary),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isToday) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  onPressed: () => _addMealToDay(date),
                  color: AppColors.accent,
                  tooltip: 'Add meal',
                ),
              ],
            ),
          ),

          // Meals
          if (dayPlans.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Text(
                'No meals planned',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...dayPlans.map((mealPlan) => _buildMealItem(mealPlan)),
        ],
      ),
    );
  }

  Widget _buildMealItem(MealPlan mealPlan) {
    return Dismissible(
      key: Key(mealPlan.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.m),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _removeMeal(mealPlan),
      child: InkWell(
        onTap: () async {
          final recipes = await _storageService.getSavedRecipes();
          final recipe = recipes.firstWhere(
            (r) => r.id == mealPlan.recipeId,
            orElse: () => recipes.first,
          );
          
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeScreenEnhanced(recipe: recipe),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.divider, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Text(
                mealPlan.cuisineEmoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealPlan.recipeTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mealPlan.mealType,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  String _getWeekRange() {
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    if (_weekStart.month == weekEnd.month) {
      return '${months[_weekStart.month - 1]} ${_weekStart.day} - ${weekEnd.day}, ${_weekStart.year}';
    } else {
      return '${months[_weekStart.month - 1]} ${_weekStart.day} - ${months[weekEnd.month - 1]} ${weekEnd.day}, ${_weekStart.year}';
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
}

class _RecipePickerDialog extends StatelessWidget {
  final List<Recipe> recipes;

  const _RecipePickerDialog({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a Recipe'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return ListTile(
              leading: Text(
                _getCuisineEmoji(recipe.cuisineType),
                style: const TextStyle(fontSize: 32),
              ),
              title: Text(recipe.title),
              subtitle: Text('${recipe.totalTime} min • ${recipe.cuisineType}'),
              onTap: () => Navigator.pop(context, recipe),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  String _getCuisineEmoji(String cuisine) {
    final emojiMap = {
      'Italian': '🍝',
      'Asian': '🍜',
      'Mexican': '🌮',
      'American': '🍔',
      'Mediterranean': '🥗',
      'Indian': '🍛',
      'French': '🥐',
      'Thai': '🍲',
    };
    return emojiMap[cuisine] ?? '🍽️';
  }
}
