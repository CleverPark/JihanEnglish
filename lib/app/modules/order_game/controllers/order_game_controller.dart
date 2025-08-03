import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/storage_service.dart';
import '../../../core/values/app_constants.dart';
import '../../../data/models/book_model.dart';
import '../../../modules/home/controllers/home_controller.dart';

class OrderGameController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final Rx<BookModel?> currentBook = Rx<BookModel?>(null);
  final RxList<String> shuffledSentences = <String>[].obs;
  final RxList<String> originalSentences = <String>[].obs;
  final RxBool isCompleted = false.obs;
  final RxBool isCheckingAnswer = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['book'] != null) {
      currentBook.value = args['book'];
      loadSentences();
    }
  }

  void loadSentences() {
    if (currentBook.value != null) {
      originalSentences.value = List.from(currentBook.value!.sentences);
      shuffledSentences.value = List.from(currentBook.value!.sentences);
      shuffledSentences.shuffle();
    }
  }

  void reorderSentences(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = shuffledSentences.removeAt(oldIndex);
    shuffledSentences.insert(newIndex, item);
  }

  void checkAnswer() {
    if (isCheckingAnswer.value || isCompleted.value) return;
    
    isCheckingAnswer.value = true;
    
    bool isCorrect = true;
    for (int i = 0; i < shuffledSentences.length; i++) {
      if (shuffledSentences[i] != originalSentences[i]) {
        isCorrect = false;
        break;
      }
    }
    
    if (isCorrect) {
      completeGame();
    } else {
      showIncorrectDialog();
    }
    
    isCheckingAnswer.value = false;
  }

  void showIncorrectDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('틀렸습니다'),
        content: const Text('순서를 다시 확인해보세요.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  void completeGame() {
    if (isCompleted.value) return;
    
    isCompleted.value = true;
    
    // Update user data
    final user = _storageService.getUserData();
    if (user != null && currentBook.value != null) {
      // Update completed games
      final bookKey = currentBook.value!.bookNum.toString();
      final completedBooks = Map<String, Map<String, bool>>.from(user.completedBooks);
      
      if (!completedBooks.containsKey(bookKey)) {
        completedBooks[bookKey] = {};
      }
      completedBooks[bookKey]!['orderGame'] = true;
      
      final updatedUser = user.copyWith(
        completedBooks: completedBooks,
        lastPlayed: DateTime.now(),
      );
      
      _storageService.saveUserData(updatedUser);
      
      // Add experience points
      final homeController = Get.find<HomeController>();
      homeController.updateUserExp(AppConstants.orderGameExp);
      
      // Show completion dialog
      Get.dialog(
        AlertDialog(
          title: const Text('정답입니다!'),
          content: Text('${AppConstants.orderGameExp} EXP를 획득했습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Return to game menu
              },
              child: const Text('확인'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }
}