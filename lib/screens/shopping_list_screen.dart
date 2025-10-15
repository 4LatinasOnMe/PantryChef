import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/shopping_list_item.dart';
import '../services/shopping_list_service.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final ShoppingListService _shoppingListService = ShoppingListService();
  List<ShoppingListItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _shoppingListService.getShoppingList();
    if (mounted) {
      setState(() {
        _items = items;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleItem(String itemId) async {
    await _shoppingListService.toggleItem(itemId);
    await _loadItems();
  }

  Future<void> _removeItem(String itemId) async {
    await _shoppingListService.removeItem(itemId);
    await _loadItems();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed')),
      );
    }
  }

  Future<void> _clearChecked() async {
    final checkedCount = _items.where((item) => item.isChecked).length;
    
    if (checkedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No checked items to remove')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Checked Items?'),
        content: Text('Remove $checkedCount checked item${checkedCount > 1 ? 's' : ''}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.success,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _shoppingListService.removeCheckedItems();
      await _loadItems();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$checkedCount item${checkedCount > 1 ? 's' : ''} removed')),
        );
      }
    }
  }

  Future<void> _clearAll() async {
    if (_items.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Shopping List?'),
        content: const Text('This will remove all items from your shopping list.'),
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
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _shoppingListService.clearAll();
      await _loadItems();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shopping list cleared')),
        );
      }
    }
  }

  Map<String, List<ShoppingListItem>> _groupByRecipe(List<ShoppingListItem> items) {
    final Map<String, List<ShoppingListItem>> grouped = {};
    for (var item in items) {
      if (!grouped.containsKey(item.recipeTitle)) {
        grouped[item.recipeTitle] = [];
      }
      grouped[item.recipeTitle]!.add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final uncheckedItems = _items.where((item) => !item.isChecked).toList();
    final checkedItems = _items.where((item) => item.isChecked).toList();
    final groupedUnchecked = _groupByRecipe(uncheckedItems);
    final groupedChecked = _groupByRecipe(checkedItems);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List (${uncheckedItems.length})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_items.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear_checked') {
                  _clearChecked();
                } else if (value == 'clear_all') {
                  _clearAll();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'clear_checked',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Clear Checked'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                      SizedBox(width: 8),
                      Text('Clear All', style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? _buildEmptyState()
              : ListView(
                  padding: AppSpacing.screen,
                  children: [
                    if (uncheckedItems.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.m),
                      Text(
                        'To Buy',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      ...groupedUnchecked.entries.map((entry) => [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.s,
                            top: AppSpacing.s,
                            bottom: AppSpacing.xs,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.restaurant_menu, size: 16, color: AppColors.accent),
                              const SizedBox(width: 6),
                              Text(
                                entry.key,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...entry.value.map((item) => _buildShoppingItem(item)),
                      ]).expand((x) => x),
                    ],
                    
                    if (checkedItems.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.l),
                      Row(
                        children: [
                          Text(
                            'Checked',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${checkedItems.length})',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.m),
                      ...groupedChecked.entries.map((entry) => [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.s,
                            top: AppSpacing.s,
                            bottom: AppSpacing.xs,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.restaurant_menu, size: 16, color: AppColors.textTertiary),
                              const SizedBox(width: 6),
                              Text(
                                entry.key,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.textTertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...entry.value.map((item) => _buildShoppingItem(item)),
                      ]).expand((x) => x),
                    ],
                    
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
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
                child: Text('🛒', style: TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Your shopping list is empty',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Add ingredients from recipes to start shopping!',
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
                    'Browse Recipes',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(width: 8),
                  const Text('📖', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShoppingItem(ShoppingListItem item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.m),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _removeItem(item.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.s),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.m),
          border: Border.all(
            color: item.isChecked ? AppColors.success.withOpacity(0.3) : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: () => _toggleItem(item.id),
          borderRadius: BorderRadius.circular(AppRadius.m),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Row(
              children: [
                // Checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: item.isChecked ? AppColors.success : Colors.white,
                    border: item.isChecked
                        ? null
                        : Border.all(color: AppColors.divider, width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: item.isChecked
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: AppSpacing.m),
                
                // Item details
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: item.isChecked
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                      decoration: item.isChecked
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    child: Text(item.ingredient),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
