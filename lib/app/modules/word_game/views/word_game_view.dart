import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/app_spacing.dart';
import '../../../core/values/app_constants.dart';
import '../controllers/word_game_controller.dart';

class WordGameView extends GetView<WordGameController> {
  const WordGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildWordDisplay(),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.close,
                size: 28.sp,
              ),
            ),
            Text(
              '${controller.currentWordIndex.value + 1} / ${controller.words.length}',
              style: AppTextStyles.heading2,
            ),
            SizedBox(width: 48.w),
          ],
        ),
      );
    });
  }

  Widget _buildWordDisplay() {
    return Obx(() {
      if (controller.words.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return GestureDetector(
        onHorizontalDragUpdate: controller.onHorizontalDragUpdate,
        onHorizontalDragEnd: controller.onHorizontalDragEnd,
        child: PageView.builder(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.words.length,
          itemBuilder: (context, index) {
            return Center(
              child: Transform.translate(
                offset: Offset(controller.dragPosition.value * 0.2, 0),
                child: Text(
                  controller.words[index],
                  style: AppTextStyles.gameText.copyWith(
                    fontSize: 64.sp,
                    color: AppColors.primary,
                  ),
                ).animate()
                  .fadeIn(duration: 300.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 300.ms,
                  ),
              ),
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
          Icon(
            Icons.swipe,
            size: 32.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '← 스와이프하세요 →',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Obx(() {
            return AnimatedOpacity(
              opacity: controller.currentWordIndex.value == controller.words.length - 1 ? 1.0 : 0.0,
              duration: AppConstants.shortAnimationDuration,
              child: ElevatedButton(
                onPressed: controller.isCompleted.value ? null : controller.completeGame,
                child: Text(
                  '완료',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}