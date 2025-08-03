import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/storage_service.dart';
import '../../../core/values/app_constants.dart';
import '../../../data/models/book_model.dart';
import '../../../data/models/user_model.dart';
import '../../../modules/home/controllers/home_controller.dart';

class WordGameController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final Rx<BookModel?> currentBook = Rx<BookModel?>(null);
  final RxList<String> words = <String>[].obs;
  final RxInt currentWordIndex = 0.obs;
  final RxBool isCompleted = false.obs;
  final RxDouble dragPosition = 0.0.obs;

  PageController? pageController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['book'] != null) {
      currentBook.value = args['book'];
      loadWords();
    }
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController?.dispose();
    super.onClose();
  }

  void loadWords() {
    if (currentBook.value != null) {
      words.value = currentBook.value!.allWords;
    }
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    dragPosition.value += details.delta.dx;
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (dragPosition.value.abs() > AppConstants.swipeThreshold) {
      if (dragPosition.value < 0) {
        nextWord();
      } else {
        previousWord();
      }
    }
    dragPosition.value = 0.0;
  }

  void nextWord() {
    if (currentWordIndex.value < words.length - 1) {
      currentWordIndex.value++;
      pageController?.animateToPage(
        currentWordIndex.value,
        duration: AppConstants.shortAnimationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      completeGame();
    }
  }

  void previousWord() {
    if (currentWordIndex.value > 0) {
      currentWordIndex.value--;
      pageController?.animateToPage(
        currentWordIndex.value,
        duration: AppConstants.shortAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
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
      completedBooks[bookKey]!['wordGame'] = true;
      
      final updatedUser = user.copyWith(
        completedBooks: completedBooks,
        lastPlayed: DateTime.now(),
      );
      
      _storageService.saveUserData(updatedUser);
      
      // Add experience points
      final homeController = Get.find<HomeController>();
      homeController.updateUserExp(AppConstants.wordGameExp * words.length);
      
      // Show completion dialog
      Get.dialog(
        AlertDialog(
          title: const Text('게임 완료!'),
          content: Text('${AppConstants.wordGameExp * words.length} EXP를 획득했습니다!'),
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