import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/values/app_spacing.dart';
import '../data/models/book_model.dart';

class BookCardWidget extends StatelessWidget {
  final BookModel book;
  final double progress;
  final VoidCallback onTap;
  final Map<String, int>? completionCounts;

  const BookCardWidget({
    super.key,
    required this.book,
    required this.progress,
    required this.onTap,
    this.completionCounts,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book,
                size: 24.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                '책 ${book.bookNum}',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                book.title,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (progress > 0) ...[
                SizedBox(height: AppSpacing.xs),
                Container(
                  width: 60.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4.h,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 1 ? AppColors.success : AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              ],
              if (completionCounts != null && completionCounts!.isNotEmpty) ...[
                SizedBox(height: AppSpacing.xs),
                _buildCompletionCounts(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionCounts() {
    if (completionCounts == null || completionCounts!.isEmpty) {
      return const SizedBox.shrink();
    }

    List<String> completedGames = [];
    
    if (completionCounts!['wordGame'] != null && completionCounts!['wordGame']! > 0) {
      completedGames.add('게임1:${completionCounts!['wordGame']}회');
    }
    if (completionCounts!['sentenceGame'] != null && completionCounts!['sentenceGame']! > 0) {
      completedGames.add('게임2:${completionCounts!['sentenceGame']}회');
    }
    if (completionCounts!['orderGame'] != null && completionCounts!['orderGame']! > 0) {
      completedGames.add('게임3:${completionCounts!['orderGame']}회');
    }

    if (completedGames.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      completedGames.join(', '),
      style: AppTextStyles.body2.copyWith(
        fontSize: 9.sp,
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}