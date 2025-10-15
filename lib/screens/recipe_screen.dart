import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/recipe.dart';
import '../services/storage_service.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeScreen({super.key, required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final StorageService _storageService = StorageService();
  late Recipe _recipe;
  Set<int> _checkedIngredients = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
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
                    icon: Icons.people_outline,
                    label: 'SERVES',
                    value: '${_recipe.servings}',
                  ),
                ),
              ],
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
                _recipe.ingredients[index],
                _checkedIngredients.contains(index),
              );
            }),
            
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
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s,
        horizontal: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
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
              color: AppColors.textTertiary,
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
    return InkWell(
      onTap: () => _toggleIngredient(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
        child: Row(
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.success : Colors.white,
                border: isChecked
                    ? null
                    : Border.all(color: AppColors.divider, width: 2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: AppSpacing.s),
            // Ingredient text
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: isChecked ? AppColors.textTertiary : AppColors.textPrimary,
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
}
