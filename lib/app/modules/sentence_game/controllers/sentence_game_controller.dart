import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/storage_service.dart';
import '../../../core/values/app_constants.dart';
import '../../../data/models/book_model.dart';
import '../../../modules/home/controllers/home_controller.dart';
import '../../../modules/game_menu/controllers/game_menu_controller.dart';

class SentenceGameController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final Rx<BookModel?> currentBook = Rx<BookModel?>(null);
  final RxList<String> sentences = <String>[].obs;
  final RxInt currentSentenceIndex = 0.obs;
  final RxBool isCompleted = false.obs;
  final RxDouble dragPosition = 0.0.obs;

  PageController? pageController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['book'] != null) {
      currentBook.value = args['book'];
      loadSentences();
    }
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController?.dispose();
    super.onClose();
  }

  void loadSentences() {
    if (currentBook.value != null) {
      sentences.value = currentBook.value!.sentences;
    }
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    dragPosition.value += details.delta.dx;
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (dragPosition.value.abs() > AppConstants.swipeThreshold) {
      if (dragPosition.value < 0) {
        nextSentence();
      } else {
        previousSentence();
      }
    }
    dragPosition.value = 0.0;
  }

  void nextSentence() {
    if (currentSentenceIndex.value < sentences.length - 1) {
      currentSentenceIndex.value++;
      pageController?.animateToPage(
        currentSentenceIndex.value,
        duration: AppConstants.shortAnimationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      completeGame();
    }
  }

  void previousSentence() {
    if (currentSentenceIndex.value > 0) {
      currentSentenceIndex.value--;
      pageController?.animateToPage(
        currentSentenceIndex.value,
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
      final completionCounts = Map<String, Map<String, int>>.from(user.completionCounts);
      
      if (!completedBooks.containsKey(bookKey)) {
        completedBooks[bookKey] = {};
      }
      if (!completionCounts.containsKey(bookKey)) {
        completionCounts[bookKey] = {};
      }
      
      completedBooks[bookKey]!['sentenceGame'] = true;
      completionCounts[bookKey]!['sentenceGame'] = (completionCounts[bookKey]!['sentenceGame'] ?? 0) + 1;
      
      final updatedUser = user.copyWith(
        completedBooks: completedBooks,
        completionCounts: completionCounts,
        lastPlayed: DateTime.now(),
      );
      
      _storageService.saveUserData(updatedUser);
      
      // Add experience points
      final homeController = Get.find<HomeController>();
      homeController.updateUserExp(AppConstants.sentenceGameExp * sentences.length);
      
      // Update game menu completion counts
      try {
        final gameMenuController = Get.find<GameMenuController>();
        gameMenuController.refreshCompletionCounts();
      } catch (e) {
        // GameMenuController might not be available
      }
      
      // Update home controller to refresh book cards
      try {
        homeController.update();
      } catch (e) {
        // HomeController might not be available
      }
      
      // Show completion dialog
      Get.dialog(
        AlertDialog(
          title: const Text('게임 완료!'),
          content: Text('${AppConstants.sentenceGameExp * sentences.length} EXP를 획득했습니다!'),
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