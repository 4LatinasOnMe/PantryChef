import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/nutrition_info.dart';

class NutritionCard extends StatelessWidget {
  final NutritionInfo nutrition;

  const NutritionCard({super.key, required this.nutrition});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.accent.withOpacity(0.2),
                  AppColors.accentLight.withOpacity(0.1),
                ]
              : [
                  AppColors.accent.withOpacity(0.1),
                  AppColors.accentLight.withOpacity(0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(
          color: AppColors.accent.withOpacity(isDark ? 0.4 : 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.restaurant_menu, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Nutrition Facts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getHealthScoreColor(nutrition.healthScore),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Health: ${nutrition.healthScore}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.m),
          
          // Calories
          Row(
            children: [
              Text(
                '${nutrition.calories}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'calories',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.m),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.m),
          
          // Macros
          Row(
            children: [
              Expanded(
                child: _buildMacroItem(
                  'Protein',
                  '${nutrition.protein.toStringAsFixed(1)}g',
                  '${nutrition.proteinPercent}%',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildMacroItem(
                  'Carbs',
                  '${nutrition.carbs.toStringAsFixed(1)}g',
                  '${nutrition.carbsPercent}%',
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildMacroItem(
                  'Fat',
                  '${nutrition.fat.toStringAsFixed(1)}g',
                  '${nutrition.fatPercent}%',
                  Colors.purple,
                ),
              ),
            ],
          ),
          
          // Dietary Labels
          if (nutrition.dietaryLabels.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.m),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.m),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: nutrition.dietaryLabels.map((label) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.success.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          
          // Allergens
          if (nutrition.allergens.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s),
            Row(
              children: [
                const Icon(Icons.warning_amber, size: 16, color: AppColors.error),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Contains: ${nutrition.allergens.join(', ')}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          // Disclaimer
          const SizedBox(height: AppSpacing.s),
          Text(
            '* Nutritional information is AI-estimated per serving and may vary',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String amount, String percent, Color color) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          percent,
          style: TextStyle(
            fontSize: 10,
            color: color.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Color _getHealthScoreColor(int score) {
    if (score >= 75) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }
}
