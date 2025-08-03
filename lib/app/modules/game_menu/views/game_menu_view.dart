import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/app_spacing.dart';
import '../../../core/values/app_constants.dart';
import '../../../widgets/game_card_widget.dart';
import '../controllers/game_menu_controller.dart';

class GameMenuView extends GetView<GameMenuController> {
  const GameMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: AppSpacing.xl),
              Expanded(
                child: _buildGameOptions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      if (controller.currentBook.value == null) return const SizedBox.shrink();
      
      return Row(
        children: [
          IconButton(
            onPressed: controller.goBack,
            icon: Icon(
              Icons.arrow_back,
              size: 28.sp,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              controller.currentBook.value!.title,
              style: AppTextStyles.heading1,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 48.w), // Balance for back button
        ],
      ).animate().fadeIn().slideY(begin: -0.2);
    });
  }

  Widget _buildGameOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GameCardWidget(
          icon: Icons.abc,
          title: '게임 1',
          subtitle: '단어 읽기',
          exp: AppConstants.wordGameExp,
          color: AppColors.primary,
          onTap: controller.navigateToWordGame,
        ).animate()
          .fadeIn(delay: 300.ms)
          .slideX(begin: -0.2),
        
        SizedBox(height: AppSpacing.lg),
        
        GameCardWidget(
          icon: Icons.text_fields,
          title: '게임 2',
          subtitle: '문장 읽기',
          exp: AppConstants.sentenceGameExp,
          color: AppColors.secondary,
          onTap: controller.navigateToSentenceGame,
        ).animate()
          .fadeIn(delay: 500.ms)
          .slideX(begin: -0.2),
        
        SizedBox(height: AppSpacing.lg),
        
        GameCardWidget(
          icon: Icons.shuffle,
          title: '게임 3',
          subtitle: '문장 순서 맞추기',
          exp: AppConstants.orderGameExp,
          color: AppColors.success,
          onTap: controller.navigateToOrderGame,
        ).animate()
          .fadeIn(delay: 700.ms)
          .slideX(begin: -0.2),
      ],
    );
  }
}