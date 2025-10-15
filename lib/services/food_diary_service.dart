import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_diary_entry.dart';

class FoodDiaryService {
  static const String _entriesKey = 'food_diary_entries';
  static const String _calorieGoalKey = 'daily_calorie_goal';
  static const int _defaultCalorieGoal = 2000;

  // Get calorie goal
  Future<int> getCalorieGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_calorieGoalKey) ?? _defaultCalorieGoal;
  }

  // Set calorie goal
  Future<void> setCalorieGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_calorieGoalKey, goal);
  }

  // Get all entries
  Future<List<FoodDiaryEntry>> getAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_entriesKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => FoodDiaryEntry.fromJson(json)).toList();
  }

  // Get entries for a specific date
  Future<List<FoodDiaryEntry>> getEntriesForDate(DateTime date) async {
    final allEntries = await getAllEntries();
    return allEntries.where((entry) {
      return entry.date.year == date.year &&
             entry.date.month == date.month &&
             entry.date.day == date.day;
    }).toList();
  }

  // Get entries for a date range
  Future<List<FoodDiaryEntry>> getEntriesForDateRange(DateTime start, DateTime end) async {
    final allEntries = await getAllEntries();
    return allEntries.where((entry) {
      return entry.date.isAfter(start.subtract(const Duration(days: 1))) &&
             entry.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Get daily summary
  Future<DailySummary> getDailySummary(DateTime date) async {
    final entries = await getEntriesForDate(date);
    final goal = await getCalorieGoal();
    
    int totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    
    for (var entry in entries) {
      totalCalories += entry.calories;
      totalProtein += entry.protein;
      totalCarbs += entry.carbs;
      totalFat += entry.fat;
    }
    
    return DailySummary(
      date: date,
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
      calorieGoal: goal,
      entries: entries,
    );
  }

  // Add entry
  Future<void> addEntry(FoodDiaryEntry entry) async {
    final entries = await getAllEntries();
    entries.add(entry);
    await _saveEntries(entries);
  }

  // Delete entry
  Future<void> deleteEntry(String entryId) async {
    final entries = await getAllEntries();
    entries.removeWhere((entry) => entry.id == entryId);
    await _saveEntries(entries);
  }

  // Update entry
  Future<void> updateEntry(FoodDiaryEntry updatedEntry) async {
    final entries = await getAllEntries();
    final index = entries.indexWhere((entry) => entry.id == updatedEntry.id);
    if (index != -1) {
      entries[index] = updatedEntry;
      await _saveEntries(entries);
    }
  }

  // Get entries by meal type for a date
  Future<List<FoodDiaryEntry>> getEntriesByMealType(DateTime date, String mealType) async {
    final dayEntries = await getEntriesForDate(date);
    return dayEntries.where((entry) => entry.mealType == mealType).toList();
  }

  // Calculate calories for meal type
  Future<int> getCaloriesForMealType(DateTime date, String mealType) async {
    final entries = await getEntriesByMealType(date, mealType);
    return entries.fold<int>(0, (sum, entry) => sum + entry.calories);
  }

  // Private helper to save entries
  Future<void> _saveEntries(List<FoodDiaryEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((entry) => entry.toJson()).toList();
    await prefs.setString(_entriesKey, jsonEncode(jsonList));
  }

  // Get weekly average calories
  Future<double> getWeeklyAverageCalories(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final entries = await getEntriesForDateRange(weekStart, weekEnd);
    
    if (entries.isEmpty) return 0;
    
    final totalCalories = entries.fold<int>(0, (sum, entry) => sum + entry.calories);
    return totalCalories / 7;
  }
}
