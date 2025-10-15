import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ServingAdjuster extends StatelessWidget {
  final int currentServings;
  final int originalServings;
  final Function(int) onServingsChanged;

  const ServingAdjuster({
    super.key,
    required this.currentServings,
    required this.originalServings,
    required this.onServingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: currentServings > 1
                ? () => onServingsChanged(currentServings - 1)
                : null,
            color: AppColors.accent,
            iconSize: 28,
          ),
          const SizedBox(width: AppSpacing.s),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$currentServings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              Text(
                'servings',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.s),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: currentServings < 20
                ? () => onServingsChanged(currentServings + 1)
                : null,
            color: AppColors.accent,
            iconSize: 28,
          ),
        ],
      ),
    );
  }
}
