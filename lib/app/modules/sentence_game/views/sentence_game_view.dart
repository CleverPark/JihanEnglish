import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/app_spacing.dart';
import '../../../core/values/app_constants.dart';
import '../controllers/sentence_game_controller.dart';

class SentenceGameView extends GetView<SentenceGameController> {
  const SentenceGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildSentenceDisplay(),
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
              '${controller.currentSentenceIndex.value + 1} / ${controller.sentences.length}',
              style: AppTextStyles.heading2,
            ),
            SizedBox(width: 48.w),
          ],
        ),
      );
    });
  }

  Widget _buildSentenceDisplay() {
    return Obx(() {
      if (controller.sentences.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return GestureDetector(
        onHorizontalDragUpdate: controller.onHorizontalDragUpdate,
        onHorizontalDragEnd: controller.onHorizontalDragEnd,
        child: PageView.builder(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.sentences.length,
          itemBuilder: (context, index) {
            return Center(
              child: Transform.translate(
                offset: Offset(controller.dragPosition.value * 0.2, 0),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    controller.sentences[index],
                    style: AppTextStyles.gameText.copyWith(
                      fontSize: 36.sp,
                      color: AppColors.secondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ).animate()
                    .fadeIn(duration: 300.ms)
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      duration: 300.ms,
                    ),
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
              opacity: controller.currentSentenceIndex.value == controller.sentences.length - 1 ? 1.0 : 0.0,
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