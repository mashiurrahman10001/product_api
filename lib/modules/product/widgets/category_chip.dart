import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../data/models/category_model.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Chip(
          label: Text(
            category.name,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          backgroundColor: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey[200],
          side: isSelected
              ? BorderSide(color: AppColors.primary)
              : BorderSide.none,
        ),
      ),
    );
  }
}