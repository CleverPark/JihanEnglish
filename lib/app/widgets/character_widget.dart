import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/values/app_spacing.dart';
import '../data/models/character_model.dart';

class CharacterWidget extends StatelessWidget {
  final CharacterModel character;

  const CharacterWidget({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 150.w,
            height: 150.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight.withOpacity(0.2),
            ),
            child: Image.asset(
              character.imagePath,
              width: 120.w,
              height: 120.w,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            character.title,
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}