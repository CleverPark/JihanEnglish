import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/app_spacing.dart';
import '../../../widgets/level_bar_widget.dart';
import '../../../widgets/character_widget.dart';
import '../../../widgets/book_card_widget.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Header with user info
              _buildHeader(),
              SizedBox(height: AppSpacing.lg),
              
              // Character display
              _buildCharacterSection(),
              SizedBox(height: AppSpacing.lg),
              
              // Books grid
              Expanded(
                child: _buildBooksGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      if (controller.user.value == null) return const SizedBox.shrink();
      
      final user = controller.user.value!;
      
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '이름: ${user.userName}',
                  style: AppTextStyles.heading2,
                ),
                Text(
                  'Lv.${user.level}',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            LevelBarWidget(
              currentExp: user.currentExp,
              requiredExp: user.requiredExp,
              progress: controller.levelProgress.value,
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: -0.2);
    });
  }

  Widget _buildCharacterSection() {
    return Obx(() {
      if (controller.currentCharacter.value == null) return const SizedBox.shrink();
      
      return CharacterWidget(
        character: controller.currentCharacter.value!,
      ).animate()
        .fadeIn(delay: 300.ms)
        .scale(delay: 300.ms);
    });
  }

  Widget _buildBooksGrid() {
    return Obx(() {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.2,
        ),
        itemCount: controller.books.length,
        itemBuilder: (context, index) {
          final book = controller.books[index];
          final progress = controller.getBookProgress(book.bookNum);
          
          return BookCardWidget(
            book: book,
            progress: progress,
            onTap: () => controller.navigateToGameMenu(book.bookNum),
          ).animate()
            .fadeIn(delay: Duration(milliseconds: 400 + (index * 100)))
            .scale(delay: Duration(milliseconds: 400 + (index * 100)));
        },
      );
    });
  }
}