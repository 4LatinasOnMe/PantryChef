import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/food_diary_entry.dart';
import '../models/recipe.dart';
import '../models/nutrition_info.dart';
import '../services/food_diary_service.dart';
import '../services/storage_service.dart';

class FoodDiaryScreen extends StatefulWidget {
  const FoodDiaryScreen({super.key});

  @override
  State<FoodDiaryScreen> createState() => _FoodDiaryScreenState();
}

class _FoodDiaryScreenState extends State<FoodDiaryScreen> {
  final FoodDiaryService _diaryService = FoodDiaryService();
  final StorageService _storageService = StorageService();
  
  DateTime _selectedDate = DateTime.now();
  DailySummary? _dailySummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDailySummary();
  }

  Future<void> _loadDailySummary() async {
    final summary = await _diaryService.getDailySummary(_selectedDate);
    if (mounted) {
      setState(() {
        _dailySummary = summary;
        _isLoading = false;
      });
    }
  }

  Future<void> _changeDate(int days) async {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      _isLoading = true;
    });
    await _loadDailySummary();
  }

  Future<void> _goToToday() async {
    setState(() {
      _selectedDate = DateTime.now();
      _isLoading = true;
    });
    await _loadDailySummary();
  }

  Future<void> _addMealFromRecipe(String mealType) async {
    final recipes = await _storageService.getSavedRecipes();
    
    if (recipes.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No saved recipes. Save some recipes first!')),
        );
      }
      return;
    }

    if (!mounted) return;
    
    final selectedRecipe = await showDialog<Recipe>(
      context: context,
      builder: (context) => _RecipePickerDialog(recipes: recipes),
    );

    if (selectedRecipe != null && mounted) {
      // Get nutrition info
      final nutrition = selectedRecipe.nutritionData != null
          ? NutritionInfo.fromJson(selectedRecipe.nutritionData!)
          : null;

      final entry = FoodDiaryEntry(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        date: _selectedDate,
        mealType: mealType,
        foodName: selectedRecipe.title,
        calories: nutrition?.calories ?? 0,
        protein: nutrition?.protein ?? 0,
        carbs: nutrition?.carbs ?? 0,
        fat: nutrition?.fat ?? 0,
        recipeId: selectedRecipe.id,
      );

      await _diaryService.addEntry(entry);
      await _loadDailySummary();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${selectedRecipe.title} added to $mealType')),
        );
      }
    }
  }

  Future<void> _addCustomMeal(String mealType) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _CustomMealDialog(mealType: mealType),
    );

    if (result != null) {
      final entry = FoodDiaryEntry(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        date: _selectedDate,
        mealType: mealType,
        foodName: result['name'],
        calories: result['calories'],
        protein: result['protein'],
        carbs: result['carbs'],
        fat: result['fat'],
        notes: result['notes'],
      );

      await _diaryService.addEntry(entry);
      await _loadDailySummary();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${result['name']} added to $mealType')),
        );
      }
    }
  }

  Future<void> _deleteEntry(FoodDiaryEntry entry) async {
    await _diaryService.deleteEntry(entry.id);
    await _loadDailySummary();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry deleted')),
      );
    }
  }

  Future<void> _editCalorieGoal() async {
    final currentGoal = await _diaryService.getCalorieGoal();
    final controller = TextEditingController(text: currentGoal.toString());

    if (!mounted) return;
    
    final newGoal = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Daily Calorie Goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Calories',
            suffixText: 'cal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final goal = int.tryParse(controller.text);
              if (goal != null && goal > 0) {
                Navigator.pop(context, goal);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newGoal != null) {
      await _diaryService.setCalorieGoal(newGoal);
      await _loadDailySummary();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _goToToday,
            tooltip: 'Go to today',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _editCalorieGoal,
            tooltip: 'Set calorie goal',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Date Navigator
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    color: isDark ? const Color(0xFF1E1E1E) : AppColors.background,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => _changeDate(-1),
                        ),
                        Expanded(
                          child: Text(
                            _formatDate(_selectedDate),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => _changeDate(1),
                        ),
                      ],
                    ),
                  ),

                  // Calorie Summary Card
                  _buildCalorieSummary(isDark),

                  // Meals
                  Padding(
                    padding: AppSpacing.screen,
                    child: Column(
                      children: [
                        _buildMealSection('Breakfast', '🌅', isDark),
                        const SizedBox(height: AppSpacing.m),
                        _buildMealSection('Lunch', '🌞', isDark),
                        const SizedBox(height: AppSpacing.m),
                        _buildMealSection('Dinner', '🌙', isDark),
                        const SizedBox(height: AppSpacing.m),
                        _buildMealSection('Snack', '🍎', isDark),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCalorieSummary(bool isDark) {
    if (_dailySummary == null) return const SizedBox();

    final summary = _dailySummary!;
    final progressColor = summary.overGoal
        ? AppColors.error
        : (summary.progress > 0.8 ? AppColors.success : AppColors.accent);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.m),
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2C2C2C), const Color(0xFF1E1E1E)]
              : [Colors.white, AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.l),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calories',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${summary.totalCalories}',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: progressColor,
                        ),
                      ),
                      Text(
                        ' / ${summary.calorieGoal}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDark ? Colors.white60 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  summary.overGoal
                      ? '+${summary.totalCalories - summary.calorieGoal} over'
                      : '${summary.remainingCalories} left',
                  style: TextStyle(
                    color: progressColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.m),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: summary.progress,
              minHeight: 12,
              backgroundColor: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          
          const SizedBox(height: AppSpacing.m),
          
          // Macros
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroChip('Protein', '${summary.totalProtein.toStringAsFixed(0)}g', Colors.blue, isDark),
              _buildMacroChip('Carbs', '${summary.totalCarbs.toStringAsFixed(0)}g', Colors.orange, isDark),
              _buildMacroChip('Fat', '${summary.totalFat.toStringAsFixed(0)}g', Colors.purple, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroChip(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white60 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(String mealType, String emoji, bool isDark) {
    final entries = _dailySummary?.entries
        .where((e) => e.mealType == mealType)
        .toList() ?? [];
    
    final totalCalories = entries.fold(0, (sum, entry) => sum + entry.calories);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(
          color: isDark ? const Color(0xFF3C3C3C) : AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => _showAddMealOptions(mealType),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.m),
              topRight: Radius.circular(AppRadius.m),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: AppSpacing.s),
                  Text(
                    mealType,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (totalCalories > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      '($totalCalories cal)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                  const Spacer(),
                  const Icon(Icons.add_circle_outline, color: AppColors.accent),
                ],
              ),
            ),
          ),
          
          // Entries
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Text(
                'No items added',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white38 : AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...entries.map((entry) => _buildEntryItem(entry, isDark)),
        ],
      ),
    );
  }

  Widget _buildEntryItem(FoodDiaryEntry entry, bool isDark) {
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.m),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteEntry(entry),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF3C3C3C) : AppColors.divider,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.foodName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'P: ${entry.protein.toStringAsFixed(0)}g • C: ${entry.carbs.toStringAsFixed(0)}g • F: ${entry.fat.toStringAsFixed(0)}g',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white60 : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${entry.calories} cal',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMealOptions(String mealType) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.restaurant_menu, color: AppColors.accent),
              title: const Text('Add from Recipes'),
              onTap: () {
                Navigator.pop(context);
                _addMealFromRecipe(mealType);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.accent),
              title: const Text('Add Custom Meal'),
              onTap: () {
                Navigator.pop(context);
                _addCustomMeal(mealType);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }
}

// Recipe Picker Dialog
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
            final nutrition = recipe.nutritionData != null
                ? NutritionInfo.fromJson(recipe.nutritionData!)
                : null;
            
            return ListTile(
              title: Text(recipe.title),
              subtitle: nutrition != null
                  ? Text('${nutrition.calories} cal')
                  : null,
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
}

// Custom Meal Dialog
class _CustomMealDialog extends StatefulWidget {
  final String mealType;

  const _CustomMealDialog({required this.mealType});

  @override
  State<_CustomMealDialog> createState() => _CustomMealDialogState();
}

class _CustomMealDialogState extends State<_CustomMealDialog> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Custom ${widget.mealType}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Food Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _proteinController,
              decoration: const InputDecoration(labelText: 'Protein (g)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _carbsController,
              decoration: const InputDecoration(labelText: 'Carbs (g)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _fatController,
              decoration: const InputDecoration(labelText: 'Fat (g)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _caloriesController.text.isNotEmpty) {
              Navigator.pop(context, {
                'name': _nameController.text,
                'calories': int.tryParse(_caloriesController.text) ?? 0,
                'protein': double.tryParse(_proteinController.text) ?? 0,
                'carbs': double.tryParse(_carbsController.text) ?? 0,
                'fat': double.tryParse(_fatController.text) ?? 0,
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
