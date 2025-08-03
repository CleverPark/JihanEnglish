import 'package:get/get.dart';
import '../../../core/utils/storage_service.dart';
import '../../../core/utils/level_system.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/character_model.dart';
import '../../../data/models/book_model.dart';
import '../../../routes/app_routes.dart';
import '../../../../bookData/bookData.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxList<BookModel> books = <BookModel>[].obs;
  final Rx<CharacterModel?> currentCharacter = Rx<CharacterModel?>(null);
  final RxDouble levelProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadBooks();
  }

  void loadUserData() {
    user.value = _storageService.getUserData();
    if (user.value != null) {
      levelProgress.value = LevelSystem.getProgressPercentage(
        user.value!.currentExp,
        user.value!.requiredExp,
      );
      currentCharacter.value = CharacterModel.getCharacterByLevel(user.value!.level);
    }
  }

  void loadBooks() {
    books.value = bookData.map((data) => BookModel.fromJson(data)).toList();
  }

  void navigateToGameMenu(int bookNum) {
    Get.toNamed(
      Routes.GAME_MENU,
      arguments: {'bookNum': bookNum},
    );
  }

  Map<String, int>? getBookCompletionCounts(int bookNum) {
    if (user.value == null) return null;
    
    final bookKey = bookNum.toString();
    return user.value!.completionCounts[bookKey];
  }

  void resetUserData() {
    _storageService.clearUserData();
    user.value = null;
    currentCharacter.value = null;
    levelProgress.value = 0.0;
    
    // Navigate back to welcome screen
    Get.offAllNamed(Routes.WELCOME);
  }

  void updateUserExp(int expGained) {
    if (user.value == null) return;

    // Get the most recent user data to ensure we have the latest completionCounts
    final latestUser = _storageService.getUserData();
    if (latestUser == null) return;

    final result = LevelSystem.processExp(
      latestUser.level,
      latestUser.currentExp,
      expGained,
    );

    final updatedUser = latestUser.copyWith(
      level: result.newLevel,
      currentExp: result.currentExp,
      requiredExp: result.requiredExp,
      lastPlayed: DateTime.now(),
    );

    user.value = updatedUser;
    _storageService.saveUserData(updatedUser);
    
    levelProgress.value = LevelSystem.getProgressPercentage(
      result.currentExp,
      result.requiredExp,
    );

    if (result.didLevelUp) {
      currentCharacter.value = CharacterModel.getCharacterByLevel(result.newLevel);
      showLevelUpDialog(result.newLevel);
    }
  }

  void showLevelUpDialog(int newLevel) {
    Get.snackbar(
      '레벨 업!',
      '레벨 $newLevel 달성!',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  double getBookProgress(int bookNum) {
    if (user.value == null) return 0.0;
    
    final bookKey = bookNum.toString();
    final bookData = user.value!.completedBooks[bookKey];
    
    if (bookData == null) return 0.0;
    
    int completed = 0;
    if (bookData['wordGame'] == true) completed++;
    if (bookData['sentenceGame'] == true) completed++;
    if (bookData['orderGame'] == true) completed++;
    
    return completed / 3.0;
  }
}