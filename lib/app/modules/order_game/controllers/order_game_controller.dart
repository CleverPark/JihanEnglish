import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/storage_service.dart';
import '../../../core/values/app_constants.dart';
import '../../../data/models/book_model.dart';
import '../../../modules/home/controllers/home_controller.dart';
import '../../../modules/game_menu/controllers/game_menu_controller.dart';

class SentenceItem {
  final String sentence;
  final int originalIndex;
  final String id;

  SentenceItem({
    required this.sentence,
    required this.originalIndex,
    required this.id,
  });
}

class OrderGameController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final Rx<BookModel?> currentBook = Rx<BookModel?>(null);
  final RxList<SentenceItem> shuffledSentences = <SentenceItem>[].obs;
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
      // Remove duplicate sentences
      final uniqueSentences = currentBook.value!.sentences.toSet().toList();
      originalSentences.value = List.from(uniqueSentences);
      
      // Create SentenceItem objects with unique IDs
      final sentenceItems = <SentenceItem>[];
      for (int i = 0; i < uniqueSentences.length; i++) {
        sentenceItems.add(SentenceItem(
          sentence: uniqueSentences[i],
          originalIndex: i,
          id: 'sentence_$i',
        ));
      }
      
      shuffledSentences.value = List.from(sentenceItems);
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

  void moveSentenceUp(int index) {
    if (index > 0) {
      final item = shuffledSentences.removeAt(index);
      shuffledSentences.insert(index - 1, item);
    }
  }

  void moveSentenceDown(int index) {
    if (index < shuffledSentences.length - 1) {
      final item = shuffledSentences.removeAt(index);
      shuffledSentences.insert(index + 1, item);
    }
  }

  void checkAnswer() {
    if (isCheckingAnswer.value || isCompleted.value) return;
    
    isCheckingAnswer.value = true;
    
    bool isCorrect = true;
    for (int i = 0; i < shuffledSentences.length; i++) {
      if (shuffledSentences[i].originalIndex != i) {
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
      final completionCounts = Map<String, Map<String, int>>.from(user.completionCounts);
      
      if (!completedBooks.containsKey(bookKey)) {
        completedBooks[bookKey] = {};
      }
      if (!completionCounts.containsKey(bookKey)) {
        completionCounts[bookKey] = {};
      }
      
      completedBooks[bookKey]!['orderGame'] = true;
      completionCounts[bookKey]!['orderGame'] = (completionCounts[bookKey]!['orderGame'] ?? 0) + 1;
      
      final updatedUser = user.copyWith(
        completedBooks: completedBooks,
        completionCounts: completionCounts,
        lastPlayed: DateTime.now(),
      );
      
      _storageService.saveUserData(updatedUser);
      
      // Add experience points
      final homeController = Get.find<HomeController>();
      homeController.updateUserExp(AppConstants.orderGameExp);
      
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