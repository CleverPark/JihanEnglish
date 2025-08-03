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
        child: ReorderableListView.builder(
          buildDefaultDragHandles: false,
          itemCount: controller.shuffledSentences.length,
          onReorder: controller.reorderSentences,
          itemBuilder: (context, index) {
            final sentence = controller.shuffledSentences[index];
            
            return ReorderableDragStartListener(
              key: ValueKey(sentence),
              index: index,
              child: Container(
                margin: EdgeInsets.only(bottom: AppSpacing.md),
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
                child: Row(
                  children: [
                    Icon(
                      Icons.drag_handle,
                      color: AppColors.textSecondary,
                      size: 24.sp,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        sentence,
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.2),
            );
          },
        ),
      );
    });
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text(
            '위아래로 드래그하여 순서를 바꾸세요',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Obx(() {
            return ElevatedButton(
              onPressed: controller.isCheckingAnswer.value || controller.isCompleted.value
                  ? null
                  : controller.checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
              ),
              child: controller.isCheckingAnswer.value
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      '확인하기',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                      ),
                    ),
            );
          }),
        ],
      ),
    );
  }
}