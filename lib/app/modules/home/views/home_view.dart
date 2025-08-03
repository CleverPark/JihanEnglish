import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/app_spacing.dart';
import '../../../widgets/level_bar_widget.dart';
import '../../../widgets/book_card_widget.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'English Hero',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // Top row with character and user info
                _buildTopRow(),
                SizedBox(height: AppSpacing.lg),
                
                // Books grid
                _buildBooksGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Obx(() {
      if (controller.user.value == null || controller.currentCharacter.value == null) {
        return const SizedBox.shrink();
      }
      
      final user = controller.user.value!;
      
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Character section (left)
            Expanded(
              flex: 1,
              child: _buildCharacterCard(),
            ),
            SizedBox(width: AppSpacing.md),
            // Level info section (right)
            Expanded(
              flex: 2,
              child: _buildUserInfoCard(user),
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: -0.2);
    });
  }

  Widget _buildCharacterCard() {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withOpacity(0.2),
              ),
              child: Image.asset(
                controller.currentCharacter.value!.imagePath,
                width: 80.w,
                height: 80.w,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Expanded(
            flex: 1,
            child: Text(
              controller.currentCharacter.value!.title,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: 300.ms)
      .scale(delay: 300.ms);
  }

  Widget _buildUserInfoCard(user) {
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Row(
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
          ),
          SizedBox(height: AppSpacing.sm),
          Expanded(
            flex: 2,
            child: LevelBarWidget(
              currentExp: user.currentExp,
              requiredExp: user.requiredExp,
              progress: controller.levelProgress.value,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: 500.ms)
      .slideX(begin: 0.2);
  }

  Widget _buildBooksGrid() {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: AppSpacing.xs,
            mainAxisSpacing: AppSpacing.xs,
            childAspectRatio: 1.1,
          ),
          itemCount: controller.books.length,
          itemBuilder: (context, index) {
            final book = controller.books[index];
            final progress = controller.getBookProgress(book.bookNum);
            
            return BookCardWidget(
              book: book,
              progress: progress,
              onTap: () => controller.navigateToGameMenu(book.bookNum),
              completionCounts: controller.getBookCompletionCounts(book.bookNum),
            ).animate()
              .fadeIn(delay: Duration(milliseconds: 400 + (index * 100)))
              .scale(delay: Duration(milliseconds: 400 + (index * 100)));
          },
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          _buildDrawerHeader(),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuSection(
                  title: '사용자 메뉴',
                  items: [
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: '레벨별 등급 안내',
                      onTap: () {
                        Get.back();
                        _showLevelGuideDialog();
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.bar_chart,
                      title: '내 통계 보기',
                      onTap: () {
                        Get.back();
                        _showMyStatsDialog();
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.settings,
                      title: '설정',
                      onTap: () {
                        Get.back();
                        // TODO: 설정 화면으로 이동
                      },
                    ),
                  ],
                ),
                
                Divider(height: 1),
                
                _buildMenuSection(
                  title: '개발자 메뉴',
                  items: [
                    _buildMenuItem(
                      icon: Icons.cloud_download,
                      title: '책 DB 업데이트',
                      onTap: () {
                        Get.back();
                        // TODO: 책 DB 업데이트 기능
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.delete_forever,
                      title: '데이터 초기화',
                      onTap: () {
                        Get.back();
                        _showResetDataDialog();
                      },
                    ),
                  ],
                ),
                
                Divider(height: 1),
                
                _buildMenuItem(
                  icon: Icons.info,
                  title: '앱 정보',
                  onTap: () {
                    Get.back();
                    _showAppInfoDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Obx(() {
      final user = controller.user.value;
      final character = controller.currentCharacter.value;
      
      return DrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (character != null)
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Image.asset(
                      character.imagePath,
                      width: 40.w,
                      height: 40.w,
                    ),
                  ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user != null) ...[
                        Text(
                          user.userName,
                          style: AppTextStyles.heading2.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Lv.${user.level} ${character?.title ?? ''}',
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            if (user != null)
              LinearProgressIndicator(
                value: controller.levelProgress.value,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildMenuSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Text(
            title,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.body1,
      ),
      onTap: onTap,
    );
  }

  void _showLevelGuideDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('레벨별 등급 안내'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🛡️ 견습 용사: Lv.1 ~ Lv.20'),
              SizedBox(height: 8.h),
              Text('⚔️ 초급 기사: Lv.21 ~ Lv.40'),
              SizedBox(height: 8.h),
              Text('🗡️ 중급 전사: Lv.41 ~ Lv.60'),
              SizedBox(height: 8.h),
              Text('🔮 상급 마법사: Lv.61 ~ Lv.80'),
              SizedBox(height: 8.h),
              Text('👑 전설의 영웅: Lv.81 ~ Lv.100'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showMyStatsDialog() {
    final user = controller.user.value;
    if (user == null) return;

    int totalCompletions = 0;
    user.completionCounts.forEach((bookKey, games) {
      games.forEach((gameType, count) {
        totalCompletions += count;
      });
    });

    Get.dialog(
      AlertDialog(
        title: Text('내 통계'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('현재 레벨: ${user.level}'),
            SizedBox(height: 8.h),
            Text('현재 경험치: ${user.currentExp} / ${user.requiredExp}'),
            SizedBox(height: 8.h),
            Text('총 게임 완료 횟수: $totalCompletions회'),
            SizedBox(height: 8.h),
            Text('마지막 플레이: ${user.lastPlayed.toString().split('.')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showResetDataDialog() {
    final TextEditingController passwordController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: Text('데이터 초기화'),
        content: SizedBox(
          width: 300.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('모든 게임 데이터가 삭제됩니다.'),
              SizedBox(height: 16.h),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '암호 입력',
                  hintText: '6자리 숫자',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              passwordController.dispose();
              Get.back();
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (passwordController.text == '880119') {
                passwordController.dispose();
                Get.back();
                _confirmResetData();
              } else {
                Get.snackbar(
                  '오류',
                  '암호가 올바르지 않습니다.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('확인', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _confirmResetData() {
    Get.dialog(
      AlertDialog(
        title: Text('최종 확인'),
        content: Text('정말로 모든 데이터를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              controller.resetUserData();
              Get.back();
              Get.snackbar('알림', '데이터가 초기화되었습니다.');
            },
            child: Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('앱 정보'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('English Hero'),
            SizedBox(height: 8.h),
            Text('버전: 1.0.0'),
            SizedBox(height: 8.h),
            Text('개발자: Your Name'),
            SizedBox(height: 8.h),
            Text('영어 학습을 재미있게!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }
}