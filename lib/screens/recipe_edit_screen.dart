import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';

class RecipeEditScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeEditScreen({super.key, required this.recipe});

  @override
  State<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _prepTimeController;
  late TextEditingController _cookTimeController;
  late TextEditingController _servingsController;
  late List<TextEditingController> _ingredientControllers;
  late List<TextEditingController> _instructionControllers;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);
    _descriptionController = TextEditingController(text: widget.recipe.description);
    _prepTimeController = TextEditingController(text: widget.recipe.prepTime.toString());
    _cookTimeController = TextEditingController(text: widget.recipe.cookTime.toString());
    _servingsController = TextEditingController(text: widget.recipe.servings.toString());
    
    _ingredientControllers = widget.recipe.ingredients
        .map((ing) => TextEditingController(text: ing))
        .toList();
    
    _instructionControllers = widget.recipe.instructions
        .map((inst) => TextEditingController(text: inst))
        .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _instructionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredientControllers[index].dispose();
      _ingredientControllers.removeAt(index);
    });
  }

  void _addInstruction() {
    setState(() {
      _instructionControllers.add(TextEditingController());
    });
  }

  void _removeInstruction(int index) {
    setState(() {
      _instructionControllers[index].dispose();
      _instructionControllers.removeAt(index);
    });
  }

  void _saveRecipe() {
    final editedRecipe = Recipe(
      id: widget.recipe.id,
      title: _titleController.text,
      description: _descriptionController.text,
      prepTime: int.tryParse(_prepTimeController.text) ?? widget.recipe.prepTime,
      cookTime: int.tryParse(_cookTimeController.text) ?? widget.recipe.cookTime,
      servings: int.tryParse(_servingsController.text) ?? widget.recipe.servings,
      ingredients: _ingredientControllers
          .map((c) => c.text)
          .where((text) => text.isNotEmpty)
          .toList(),
      instructions: _instructionControllers
          .map((c) => c.text)
          .where((text) => text.isNotEmpty)
          .toList(),
      cuisineType: widget.recipe.cuisineType,
      dietaryNeeds: widget.recipe.dietaryNeeds,
      mealType: widget.recipe.mealType,
      createdAt: widget.recipe.createdAt,
      isSaved: widget.recipe.isSaved,
      photoUrl: widget.recipe.photoUrl,
      nutritionData: widget.recipe.nutritionData,
      rating: widget.recipe.rating,
      notes: widget.recipe.notes,
    );

    Navigator.pop(context, editedRecipe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveRecipe,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title',
                border: OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: AppSpacing.m),
            
            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: AppSpacing.m),
            
            // Times and Servings
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _prepTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Prep Time (min)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: TextField(
                    controller: _cookTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Cook Time (min)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: TextField(
                    controller: _servingsController,
                    decoration: const InputDecoration(
                      labelText: 'Servings',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Ingredients
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.accent),
                  onPressed: _addIngredient,
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.s),
            
            ..._ingredientControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Ingredient ${index + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: AppColors.error),
                      onPressed: () => _removeIngredient(index),
                    ),
                  ],
                ),
              );
            }),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Instructions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.accent),
                  onPressed: _addInstruction,
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.s),
            
            ..._instructionControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Step ${index + 1}',
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: AppColors.error),
                      onPressed: () => _removeInstruction(index),
                    ),
                  ],
                ),
              );
            }),
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
