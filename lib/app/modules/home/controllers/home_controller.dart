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

  void updateUserExp(int expGained) {
    if (user.value == null) return;

    final result = LevelSystem.processExp(
      user.value!.level,
      user.value!.currentExp,
      expGained,
    );

    final updatedUser = user.value!.copyWith(
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