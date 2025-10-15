import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/recipe.dart';
import '../services/storage_service.dart';
import 'recipe_screen_enhanced.dart';

class CookbookScreenEnhanced extends StatefulWidget {
  const CookbookScreenEnhanced({super.key});

  @override
  State<CookbookScreenEnhanced> createState() => _CookbookScreenEnhancedState();
}

class _CookbookScreenEnhancedState extends State<CookbookScreenEnhanced> {
  final StorageService _storageService = StorageService();
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;
  
  // Search & Filter state
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCuisine;
  String? _selectedMealType;
  int? _selectedRating;
  String _sortBy = 'date'; // date, name, rating, time

  final List<String> _cuisineFilters = [
    'All',
    'Italian',
    'Asian',
    'Mexican',
    'American',
    'Mediterranean',
    'Indian',
    'French',
    'Thai',
  ];

  final List<String> _mealTypeFilters = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Dessert',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _searchController.addListener(_filterRecipes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    final recipes = await _storageService.getSavedRecipes();
    if (mounted) {
      setState(() {
        _allRecipes = recipes;
        _filteredRecipes = recipes;
        _isLoading = false;
      });
      _filterRecipes();
    }
  }

  void _filterRecipes() {
    setState(() {
      _filteredRecipes = _allRecipes.where((recipe) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            recipe.title.toLowerCase().contains(searchQuery) ||
            recipe.description.toLowerCase().contains(searchQuery) ||
            recipe.ingredients.any((i) => i.toLowerCase().contains(searchQuery));

        // Cuisine filter
        final matchesCuisine = _selectedCuisine == null ||
            _selectedCuisine == 'All' ||
            recipe.cuisineType == _selectedCuisine;

        // Meal type filter
        final matchesMealType = _selectedMealType == null ||
            _selectedMealType == 'All' ||
            recipe.mealType == _selectedMealType;

        // Rating filter
        final matchesRating = _selectedRating == null ||
            recipe.rating >= _selectedRating!;

        return matchesSearch && matchesCuisine && matchesMealType && matchesRating;
      }).toList();

      // Sort
      switch (_sortBy) {
        case 'name':
          _filteredRecipes.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'rating':
          _filteredRecipes.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'time':
          _filteredRecipes.sort((a, b) => a.totalTime.compareTo(b.totalTime));
          break;
        case 'date':
        default:
          _filteredRecipes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    });
  }

  Future<void> _deleteRecipe(Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.removeRecipe(recipe.id);
      await _loadRecipes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe deleted')),
        );
      }
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCuisine = null;
      _selectedMealType = null;
      _selectedRating = null;
      _sortBy = 'date';
    });
    _filterRecipes();
  }

  String _getRecipeIcon(Recipe recipe) {
    final cuisineIcons = {
      'Italian': '🍝',
      'Asian': '🍜',
      'Mexican': '🌮',
      'American': '🍔',
      'Mediterranean': '🥗',
      'Indian': '🍛',
      'French': '🥐',
      'Thai': '🍲',
    };

    final mealIcons = {
      'Breakfast': '🍳',
      'Lunch': '🥙',
      'Dinner': '🍽️',
      'Snack': '🥨',
      'Dessert': '🍰',
      'Appetizer': '🥟',
    };

    return cuisineIcons[recipe.cuisineType] ??
        mealIcons[recipe.mealType] ??
        '🍴';
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = _searchController.text.isNotEmpty ||
        _selectedCuisine != null ||
        _selectedMealType != null ||
        _selectedRating != null ||
        _sortBy != 'date';

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cookbook (${_allRecipes.length})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (hasActiveFilters)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearFilters,
              tooltip: 'Clear filters',
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() => _sortBy = value);
              _filterRecipes();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 20,
                        color: _sortBy == 'date'
                            ? AppColors.accent
                            : AppColors.textSecondary),
                    const SizedBox(width: 8),
                    const Text('Date Added'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'name',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha,
                        size: 20,
                        color: _sortBy == 'name'
                            ? AppColors.accent
                            : AppColors.textSecondary),
                    const SizedBox(width: 8),
                    const Text('Name'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'rating',
                child: Row(
                  children: [
                    Icon(Icons.star,
                        size: 20,
                        color: _sortBy == 'rating'
                            ? AppColors.accent
                            : AppColors.textSecondary),
                    const SizedBox(width: 8),
                    const Text('Rating'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'time',
                child: Row(
                  children: [
                    Icon(Icons.timer,
                        size: 20,
                        color: _sortBy == 'time'
                            ? AppColors.accent
                            : AppColors.textSecondary),
                    const SizedBox(width: 8),
                    const Text('Cook Time'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allRecipes.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search recipes...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.m,
                            vertical: AppSpacing.s,
                          ),
                        ),
                      ),
                    ),

                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                      ),
                      child: Row(
                        children: [
                          // Cuisine Filter
                          _buildFilterChip(
                            label: _selectedCuisine ?? 'Cuisine',
                            icon: Icons.restaurant,
                            isActive: _selectedCuisine != null,
                            onTap: () => _showCuisineFilter(),
                          ),
                          const SizedBox(width: AppSpacing.s),

                          // Meal Type Filter
                          _buildFilterChip(
                            label: _selectedMealType ?? 'Meal Type',
                            icon: Icons.schedule,
                            isActive: _selectedMealType != null,
                            onTap: () => _showMealTypeFilter(),
                          ),
                          const SizedBox(width: AppSpacing.s),

                          // Rating Filter
                          _buildFilterChip(
                            label: _selectedRating != null
                                ? '$_selectedRating+ ⭐'
                                : 'Rating',
                            icon: Icons.star_outline,
                            isActive: _selectedRating != null,
                            onTap: () => _showRatingFilter(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.m),

                    // Recipe Grid
                    Expanded(
                      child: _filteredRecipes.isEmpty
                          ? _buildNoResultsState()
                          : _buildRecipeGrid(),
                    ),
                  ],
                ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCuisineFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Text(
                  'Filter by Cuisine',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ..._cuisineFilters.map((cuisine) {
                return ListTile(
                  title: Text(cuisine),
                  trailing: _selectedCuisine == cuisine
                      ? const Icon(Icons.check, color: AppColors.accent)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCuisine = cuisine == 'All' ? null : cuisine;
                    });
                    _filterRecipes();
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: AppSpacing.m),
            ],
          ),
        );
      },
    );
  }

  void _showMealTypeFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Text(
                  'Filter by Meal Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ..._mealTypeFilters.map((mealType) {
                return ListTile(
                  title: Text(mealType),
                  trailing: _selectedMealType == mealType
                      ? const Icon(Icons.check, color: AppColors.accent)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedMealType = mealType == 'All' ? null : mealType;
                    });
                    _filterRecipes();
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: AppSpacing.m),
            ],
          ),
        );
      },
    );
  }

  void _showRatingFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Text(
                  'Filter by Rating',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                title: const Text('All Ratings'),
                trailing: _selectedRating == null
                    ? const Icon(Icons.check, color: AppColors.accent)
                    : null,
                onTap: () {
                  setState(() => _selectedRating = null);
                  _filterRecipes();
                  Navigator.pop(context);
                },
              ),
              ...List.generate(5, (index) {
                final rating = 5 - index;
                return ListTile(
                  title: Row(
                    children: [
                      Text('$rating'),
                      const SizedBox(width: 4),
                      ...List.generate(
                        rating,
                        (_) => const Icon(Icons.star,
                            size: 16, color: Colors.amber),
                      ),
                      const Text(' and up'),
                    ],
                  ),
                  trailing: _selectedRating == rating
                      ? const Icon(Icons.check, color: AppColors.accent)
                      : null,
                  onTap: () {
                    setState(() => _selectedRating = rating);
                    _filterRecipes();
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: AppSpacing.m),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.divider.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('📖', style: TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Your cookbook is empty',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Start by generating a recipe and saving your favorites!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Generate Recipe',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(width: 8),
                  const Text('🔥', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80, color: AppColors.divider),
            const SizedBox(height: AppSpacing.l),
            Text(
              'No recipes found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.l),
            TextButton(
              onPressed: _clearFilters,
              child: const Text('Clear all filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeGrid() {
    return GridView.builder(
      padding: AppSpacing.screen,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
      ),
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, index) {
        return _buildRecipeCard(_filteredRecipes[index]);
      },
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreenEnhanced(recipe: recipe),
          ),
        );
        _loadRecipes();
      },
      onLongPress: () => _showContextMenu(recipe),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2C2C2C)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.08,
              ),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getRecipeIcon(recipe),
                    style: const TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (recipe.rating > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        recipe.rating,
                        (_) => const Icon(Icons.star,
                            size: 14, color: Colors.amber),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${recipe.totalTime} min • ${recipe.servings} servings',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bookmark,
                  size: 16,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share Recipe'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share feature coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: const Text(
                  'Delete Recipe',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteRecipe(recipe);
                },
              ),
              const SizedBox(height: AppSpacing.m),
            ],
          ),
        );
      },
    );
  }
}
