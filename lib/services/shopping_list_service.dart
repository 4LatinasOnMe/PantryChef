import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopping_list_item.dart';

class ShoppingListService {
  static const String _shoppingListKey = 'shopping_list';

  // Get all shopping list items
  Future<List<ShoppingListItem>> getShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_shoppingListKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => ShoppingListItem.fromJson(json)).toList();
  }

  // Add items to shopping list
  Future<void> addItems(List<ShoppingListItem> items) async {
    final currentList = await getShoppingList();
    
    // Add new items, avoiding duplicates
    for (var item in items) {
      final exists = currentList.any((existing) => 
        existing.ingredient.toLowerCase() == item.ingredient.toLowerCase() &&
        existing.recipeId == item.recipeId
      );
      
      if (!exists) {
        currentList.add(item);
      }
    }
    
    await _saveList(currentList);
  }

  // Toggle item checked status
  Future<void> toggleItem(String itemId) async {
    final list = await getShoppingList();
    final index = list.indexWhere((item) => item.id == itemId);
    
    if (index != -1) {
      list[index] = list[index].copyWith(isChecked: !list[index].isChecked);
      await _saveList(list);
    }
  }

  // Remove a single item
  Future<void> removeItem(String itemId) async {
    final list = await getShoppingList();
    list.removeWhere((item) => item.id == itemId);
    await _saveList(list);
  }

  // Remove all checked items
  Future<void> removeCheckedItems() async {
    final list = await getShoppingList();
    list.removeWhere((item) => item.isChecked);
    await _saveList(list);
  }

  // Clear entire shopping list
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_shoppingListKey);
  }

  // Get count of items
  Future<int> getItemCount() async {
    final list = await getShoppingList();
    return list.where((item) => !item.isChecked).length;
  }

  // Private helper to save list
  Future<void> _saveList(List<ShoppingListItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((item) => item.toJson()).toList();
    await prefs.setString(_shoppingListKey, jsonEncode(jsonList));
  }
}
