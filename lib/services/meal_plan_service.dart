import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_plan.dart';

class MealPlanService {
  static const String _mealPlansKey = 'meal_plans';

  // Get all meal plans
  Future<List<MealPlan>> getAllMealPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_mealPlansKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => MealPlan.fromJson(json)).toList();
  }

  // Get meal plans for a specific date
  Future<List<MealPlan>> getMealPlansForDate(DateTime date) async {
    final allPlans = await getAllMealPlans();
    return allPlans.where((plan) {
      return plan.date.year == date.year &&
             plan.date.month == date.month &&
             plan.date.day == date.day;
    }).toList();
  }

  // Get meal plans for a week
  Future<Map<DateTime, List<MealPlan>>> getMealPlansForWeek(DateTime startDate) async {
    final allPlans = await getAllMealPlans();
    final Map<DateTime, List<MealPlan>> weekPlans = {};
    
    for (int i = 0; i < 7; i++) {
      final date = startDate.add(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      weekPlans[dateKey] = allPlans.where((plan) {
        return plan.date.year == date.year &&
               plan.date.month == date.month &&
               plan.date.day == date.day;
      }).toList();
    }
    
    return weekPlans;
  }

  // Add a meal plan
  Future<void> addMealPlan(MealPlan mealPlan) async {
    final plans = await getAllMealPlans();
    plans.add(mealPlan);
    await _savePlans(plans);
  }

  // Remove a meal plan
  Future<void> removeMealPlan(String mealPlanId) async {
    final plans = await getAllMealPlans();
    plans.removeWhere((plan) => plan.id == mealPlanId);
    await _savePlans(plans);
  }

  // Clear all meal plans
  Future<void> clearAllMealPlans() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mealPlansKey);
  }

  // Clear meal plans for a specific date
  Future<void> clearMealPlansForDate(DateTime date) async {
    final plans = await getAllMealPlans();
    plans.removeWhere((plan) {
      return plan.date.year == date.year &&
             plan.date.month == date.month &&
             plan.date.day == date.day;
    });
    await _savePlans(plans);
  }

  // Private helper to save plans
  Future<void> _savePlans(List<MealPlan> plans) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = plans.map((plan) => plan.toJson()).toList();
    await prefs.setString(_mealPlansKey, jsonEncode(jsonList));
  }
}
