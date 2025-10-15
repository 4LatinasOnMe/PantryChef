import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';
import '../services/unsplash_service.dart';
import '../services/nutrition_service.dart';
import 'recipe_screen_enhanced.dart';

class RecipeSelectionScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeSelectionScreen({
    super.key,
    required this.recipes,
  });

  @override
  State<RecipeSelectionScreen> createState() => _RecipeSelectionScreenState();
}

class _RecipeSelectionScreenState extends State<RecipeSelectionScreen> {
  final UnsplashService _unsplashService = UnsplashService();
  final NutritionService _nutritionService = NutritionService();
  final Map<String, String?> _photoUrls = {};
  bool _isLoadingPhotos = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    // Load photos for all recipes in parallel
    final futures = widget.recipes.map((recipe) async {
      try {
        final photoUrl = await _unsplashService.getRecipePhoto(
          recipeName: recipe.title,
          cuisine: recipe.cuisineType,
        );
        return MapEntry(recipe.id, photoUrl);
      } catch (e) {
        print('Error loading photo for ${recipe.title}: $e');
        return MapEntry(recipe.id, null);
      }
    }).toList();

    final results = await Future.wait(futures);
    
    if (mounted) {
      setState(() {
        for (final entry in results) {
          _photoUrls[entry.key] = entry.value;
        }
        _isLoadingPhotos = false;
      });
    }
  }

  Future<void> _selectRecipe(Recipe recipe) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Update recipe with photo if available
      if (_photoUrls[recipe.id] != null) {
        recipe.photoUrl = _photoUrls[recipe.id];
      }

      // Fetch nutrition data
      final nutrition = await _nutritionService.estimateNutrition(recipe);
      if (nutrition != null) {
        recipe.nutritionData = nutrition.toJson();
      }

      if (mounted) {
        // Close loading dialog
        Navigator.pop(context);
        
        // Navigate to recipe detail screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreenEnhanced(recipe: recipe),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading recipe details: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Recipe'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : AppColors.accent.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF4C4C4C) : AppColors.divider,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🍽️ ${widget.recipes.length} Recipe Options',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Tap any recipe to view full details and start cooking!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Recipe List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.m),
              itemCount: widget.recipes.length,
              itemBuilder: (context, index) {
                final recipe = widget.recipes[index];
                final photoUrl = _photoUrls[recipe.id];

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.m),
                  child: _buildRecipeCard(recipe, photoUrl, isDark),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe, String? photoUrl, bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: InkWell(
        onTap: () => _selectRecipe(recipe),
        borderRadius: BorderRadius.circular(AppRadius.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.l),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _isLoadingPhotos
                    ? Container(
                        color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : photoUrl != null
                        ? Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage(isDark);
                            },
                          )
                        : _buildPlaceholderImage(isDark),
              ),
            ),

            // Recipe Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Description
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.m),

                  // Recipe Meta Info
                  Wrap(
                    spacing: AppSpacing.s,
                    runSpacing: AppSpacing.s,
                    children: [
                      _buildMetaChip(
                        icon: Icons.schedule,
                        label: '${recipe.totalTime} min',
                        isDark: isDark,
                      ),
                      _buildMetaChip(
                        icon: Icons.restaurant,
                        label: '${recipe.servings} servings',
                        isDark: isDark,
                      ),
                      _buildMetaChip(
                        icon: Icons.local_fire_department,
                        label: recipe.cuisineType,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),

                  // Ingredients Preview
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_basket_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${recipe.ingredients.length} ingredients',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: 64,
          color: isDark ? Colors.white24 : Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.accent,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
