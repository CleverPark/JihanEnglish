import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/app_spacing.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSpacing.xl),
                // App Title
                Text(
                  'English Hero',
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.primary,
                    fontSize: 48.sp,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
                
                SizedBox(height: AppSpacing.sm),
                
                Text(
                  '영어 용사',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
                
                SizedBox(height: AppSpacing.xl),
                
                // Character Image
                Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight.withOpacity(0.2),
                  ),
                  child: Image.asset(
                    'lib/assets/worriorImg/tempWorrior.png',
                    width: 150.w,
                    height: 150.w,
                  ),
                ).animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms)
                  .scale(delay: 600.ms, duration: 600.ms),
                
                SizedBox(height: AppSpacing.xl),
                
                // Name Input
                Container(
                  constraints: BoxConstraints(maxWidth: 400.w),
                  child: TextField(
                    controller: controller.nameController,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body1.copyWith(fontSize: 20.sp),
                    decoration: InputDecoration(
                      hintText: '이름을 입력하세요',
                      hintStyle: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 20.sp,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 900.ms, duration: 600.ms),
                
                SizedBox(height: AppSpacing.lg),
                
                // Start Button
                Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: controller.isNameValid.value ? 200.w : 180.w,
                  child: ElevatedButton(
                    onPressed: controller.isNameValid.value && !controller.isLoading.value
                        ? controller.startGame
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      backgroundColor: controller.isNameValid.value
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            '시작하기',
                            style: AppTextStyles.button.copyWith(
                              color: Colors.white,
                              fontSize: 20.sp,
                            ),
                          ),
                  ),
                )).animate().fadeIn(delay: 1200.ms, duration: 600.ms),
                
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}