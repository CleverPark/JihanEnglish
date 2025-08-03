import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/app_spacing.dart';
import '../controllers/order_game_controller.dart';

class OrderGameView extends GetView<OrderGameController> {
  const OrderGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildSentenceList(),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.close,
              size: 28.sp,
            ),
          ),
          Expanded(
            child: Text(
              '문장을 순서대로 정렬하세요',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildSentenceList() {
    return Obx(() {
      if (controller.shuffledSentences.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: ListView.builder(
          itemCount: controller.shuffledSentences.length,
          itemBuilder: (context, index) {
            final sentenceItem = controller.shuffledSentences[index];
            
            return Container(
              key: ValueKey(sentenceItem.id),
              margin: EdgeInsets.only(bottom: AppSpacing.sm),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    '${index + 1}.',
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      sentenceItem.sentence,
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Column(
                    children: [
                      IconButton(
                        onPressed: index > 0 ? () => controller.moveSentenceUp(index) : null,
                        icon: Icon(
                          Icons.keyboard_arrow_up,
                          size: 24.sp,
                          color: index > 0 ? AppColors.primary : Colors.grey,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 32.w,
                          minHeight: 32.w,
                        ),
                      ),
                      IconButton(
                        onPressed: index < controller.shuffledSentences.length - 1 
                            ? () => controller.moveSentenceDown(index) 
                            : null,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 24.sp,
                          color: index < controller.shuffledSentences.length - 1 
                              ? AppColors.primary 
                              : Colors.grey,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 32.w,
                          minHeight: 32.w,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate()
              .fadeIn(delay: Duration(milliseconds: index * 100))
              .slideX(begin: 0.2);
          },
        ),
      );
    });
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '위아래 버튼을 눌러 순서를 바꾸세요',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Obx(() {
            return ElevatedButton(
              onPressed: controller.isCheckingAnswer.value || controller.isCompleted.value
                  ? null
                  : controller.checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                minimumSize: Size(120.w, 40.h),
              ),
              child: controller.isCheckingAnswer.value
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      '확인하기',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
            );
          }),
        ],
      ),
    );
  }
}