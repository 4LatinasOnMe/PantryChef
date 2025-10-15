import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../models/recipe.dart';
import '../models/nutrition_info.dart';
import '../models/shopping_list_item.dart';
import '../services/storage_service.dart';
import '../services/shopping_list_service.dart';
import '../services/unsplash_service.dart';
import '../services/recipe_variation_service.dart';
import '../widgets/rating_dialog.dart';
import '../widgets/serving_adjuster.dart';
import '../widgets/nutrition_card.dart';
import 'loading_screen.dart';

class RecipeScreenEnhanced extends StatefulWidget {
  final Recipe recipe;

  const RecipeScreenEnhanced({super.key, required this.recipe});

  @override
  State<RecipeScreenEnhanced> createState() => _RecipeScreenEnhancedState();
}

class _RecipeScreenEnhancedState extends State<RecipeScreenEnhanced> {
  final StorageService _storageService = StorageService();
  final ShoppingListService _shoppingListService = ShoppingListService();
  late Recipe _recipe;
  Set<int> _checkedIngredients = {};
  bool _isLoading = true;
  int _currentServings = 0;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    _currentServings = widget.recipe.servings;
    _loadData();
  }

  Future<void> _loadData() async {
    final isSaved = await _storageService.isRecipeSaved(_recipe.id);
    final checkedIndices = await _storageService.getCheckedIngredients(_recipe.id);
    
    if (mounted) {
      setState(() {
        _recipe = _recipe.copyWith(isSaved: isSaved);
        _checkedIngredients = checkedIndices.toSet();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSave() async {
    if (_recipe.isSaved) {
      await _storageService.removeRecipe(_recipe.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe removed from cookbook')),
        );
      }
    } else {
      await _storageService.saveRecipe(_recipe);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe saved to cookbook!')),
        );
      }
    }
    
    setState(() {
      _recipe = _recipe.copyWith(isSaved: !_recipe.isSaved);
    });
  }

  Future<void> _toggleIngredient(int index) async {
    setState(() {
      if (_checkedIngredients.contains(index)) {
        _checkedIngredients.remove(index);
      } else {
        _checkedIngredients.add(index);
      }
    });
    
    await _storageService.saveCheckedIngredients(
      _recipe.id,
      _checkedIngredients.toList(),
    );
  }

  Future<void> _showRatingDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => RatingDialog(
        initialRating: _recipe.rating,
        initialNotes: _recipe.notes,
      ),
    );

    if (result != null) {
      setState(() {
        _recipe = _recipe.copyWith(
          rating: result['rating'],
          notes: result['notes'],
        );
      });
      
      // Save updated recipe
      await _storageService.saveRecipe(_recipe);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating and notes saved!')),
        );
      }
    }
  }

  Future<void> _addToShoppingList() async {
    final items = _recipe.ingredients.map((ingredient) {
      return ShoppingListItem(
        id: '${_recipe.id}_${ingredient.hashCode}',
        ingredient: _adjustIngredientAmount(ingredient),
        recipeId: _recipe.id,
        recipeTitle: _recipe.title,
      );
    }).toList();

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

  Future<void> _createVariation(String variationType) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: AppSpacing.m),
              Text(
                'Creating $variationType version...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final variationService = RecipeVariationService();
      final newRecipe = await variationService.generateVariation(
        originalRecipe: _recipe,
        variationType: variationType,
      );

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        // Navigate to new recipe
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreenEnhanced(recipe: newRecipe),
          ),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$variationType version created!')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  String _adjustIngredientAmount(String ingredient) {
    if (_currentServings == _recipe.servings) {
      return ingredient;
    }

    final multiplier = _currentServings / _recipe.servings;
    
    // Try to find and adjust numbers in the ingredient
    final regex = RegExp(r'(\d+(?:\.\d+)?(?:/\d+)?)');
    return ingredient.replaceAllMapped(regex, (match) {
      final numStr = match.group(0)!;
      
      // Handle fractions
      if (numStr.contains('/')) {
        final parts = numStr.split('/');
        final numerator = double.parse(parts[0]);
        final denominator = double.parse(parts[1]);
        final decimal = numerator / denominator;
        final adjusted = decimal * multiplier;
        
        // Convert back to fraction if possible
        if (adjusted == adjusted.toInt()) {
          return adjusted.toInt().toString();
        } else if ((adjusted * 2) == (adjusted * 2).toInt()) {
          return '${(adjusted * 2).toInt()}/2';
        } else if ((adjusted * 4) == (adjusted * 4).toInt()) {
          return '${(adjusted * 4).toInt()}/4';
        }
        return adjusted.toStringAsFixed(1);
      }
      
      // Handle regular numbers
      final num = double.parse(numStr);
      final adjusted = num * multiplier;
      
      if (adjusted == adjusted.toInt()) {
        return adjusted.toInt().toString();
      }
      return adjusted.toStringAsFixed(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Rating button
          IconButton(
            icon: Icon(
              _recipe.rating > 0 ? Icons.star : Icons.star_border,
              color: _recipe.rating > 0 ? Colors.amber : AppColors.textSecondary,
            ),
            onPressed: _showRatingDialog,
            tooltip: 'Rate & add notes',
          ),
          // Bookmark button
          IconButton(
            icon: Icon(
              _recipe.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _recipe.isSaved ? AppColors.accent : AppColors.textSecondary,
            ),
            onPressed: _toggleSave,
            tooltip: _recipe.isSaved ? 'Remove from cookbook' : 'Save to cookbook',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Photo
            if (_recipe.photoUrl != null)
              CachedNetworkImage(
                imageUrl: _recipe.photoUrl!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 250,
                  color: AppColors.background,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 250,
                  color: AppColors.background,
                  child: Center(
                    child: Text(
                      UnsplashService().getFallbackEmoji(_recipe.cuisineType),
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 250,
                width: double.infinity,
                color: AppColors.background,
                child: Center(
                  child: Text(
                    UnsplashService().getFallbackEmoji(_recipe.cuisineType),
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ),
            
            Padding(
              padding: AppSpacing.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.l),
                  
                  // Recipe Title
                  Text(
                    _recipe.title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 26,
                    ),
                  ),
            
            const SizedBox(height: AppSpacing.s),
            
            // Rating Display
            if (_recipe.rating > 0)
              Row(
                children: [
                  ...List.generate(
                    _recipe.rating,
                    (_) => const Icon(Icons.star, size: 20, color: Colors.amber),
                  ),
                  ...List.generate(
                    5 - _recipe.rating,
                    (_) => const Icon(Icons.star_border, size: 20, color: Colors.amber),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_recipe.rating}/5',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            
            if (_recipe.rating > 0) const SizedBox(height: AppSpacing.s),
            
            // Description
            Text(
              _recipe.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: AppSpacing.l),
            
            // Info Cards
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.schedule,
                    label: 'PREP',
                    value: '${_recipe.prepTime} min',
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.restaurant,
                    label: 'COOK',
                    value: '${_recipe.cookTime} min',
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.timer,
                    label: 'TOTAL',
                    value: '${_recipe.totalTime} min',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.l),
            
            // Serving Size Adjuster
            Center(
              child: ServingAdjuster(
                currentServings: _currentServings,
                originalServings: _recipe.servings,
                onServingsChanged: (newServings) {
                  setState(() {
                    _currentServings = newServings;
                  });
                },
              ),
            ),
            
            if (_currentServings != _recipe.servings) ...[
              const SizedBox(height: AppSpacing.s),
              Center(
                child: Text(
                  'Adjusted from ${_recipe.servings} servings',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.accent,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: AppSpacing.l),
            
            // Nutrition Information
            if (_recipe.nutritionData != null) ...[
              NutritionCard(
                nutrition: NutritionInfo.fromJson(_recipe.nutritionData!),
              ),
              const SizedBox(height: AppSpacing.l),
            ],
            
            // Notes Section (if exists)
            if (_recipe.notes.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.accentLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.m),
                  border: Border.all(
                    color: AppColors.accentLight.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.note, size: 20, color: AppColors.accent),
                        const SizedBox(width: 8),
                        Text(
                          'My Notes',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      _recipe.notes,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.l),
            ],
            
            // Recipe Variations Section
            Builder(
              builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.m),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: AppColors.accent, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Recipe Variations',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  const SizedBox(height: AppSpacing.m),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildVariationChip('🌶️ Make it Spicy', 'Spicy'),
                      _buildVariationChip('🥗 Vegetarian', 'Vegetarian'),
                      _buildVariationChip('💚 Healthier', 'Healthier'),
                      _buildVariationChip('🌱 Vegan', 'Vegan'),
                      _buildVariationChip('🌾 Gluten-Free', 'Gluten-Free'),
                      _buildVariationChip('🥑 Low-Carb', 'Low-Carb'),
                      _buildVariationChip('⚡ Quick Version', 'Quick'),
                    ],
                  ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: AppSpacing.l),
            
            // Divider
            const Divider(height: 1),
            
            const SizedBox(height: AppSpacing.l),
            
            // Ingredients Section
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            
            const SizedBox(height: AppSpacing.m),
            
            // Ingredients List
            ...List.generate(_recipe.ingredients.length, (index) {
              return _buildIngredientItem(
                index,
                _adjustIngredientAmount(_recipe.ingredients[index]),
                _checkedIngredients.contains(index),
              );
            }),
            
            const SizedBox(height: AppSpacing.l),
            
            // Add to Shopping List Button
            OutlinedButton.icon(
              onPressed: _addToShoppingList,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Add to Shopping List'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: const BorderSide(color: AppColors.accent, width: 2),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.m),
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.l),
            
            // Divider
            const Divider(height: 1),
            
            const SizedBox(height: AppSpacing.l),
            
            // Instructions Section
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            
            const SizedBox(height: AppSpacing.m),
            
            // Instructions List
            ...List.generate(_recipe.instructions.length, (index) {
              return _buildInstructionStep(
                index + 1,
                _recipe.instructions[index],
              );
            }),
            
            const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s,
        horizontal: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.accent),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: isDark ? Colors.white60 : AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(int index, String ingredient, bool isChecked) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () {
        setState(() {
          if (isChecked) {
            _checkedIngredients.remove(index);
          } else {
            _checkedIngredients.add(index);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isChecked 
                    ? AppColors.success 
                    : (isDark ? const Color(0xFF2C2C2C) : Colors.white),
                border: isChecked
                    ? null
                    : Border.all(
                        color: isDark ? const Color(0xFF4C4C4C) : AppColors.divider, 
                        width: 2,
                      ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: AppSpacing.s),
            // ingredient text
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: isChecked 
                      ? (isDark ? Colors.white38 : AppColors.textTertiary)
                      : (isDark ? Colors.white : AppColors.textPrimary),
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
                child: Text(ingredient),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(int stepNumber, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          // Step text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                instruction,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariationChip(String label, String variationType) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ActionChip(
      label: Text(label),
      onPressed: () => _createVariation(variationType),
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      side: const BorderSide(color: AppColors.accent, width: 1),
      labelStyle: const TextStyle(
        color: AppColors.accent,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
