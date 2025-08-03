import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
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
    // Try to load from storage first, fallback to hardcoded data
    final storedBookData = _storageService.getBookData();
    final dataToUse = storedBookData ?? bookData;
    books.value = dataToUse.map((data) => BookModel.fromJson(data)).toList();
    
    print('DEBUG: Loaded ${books.length} books');
    print('DEBUG: Using ${storedBookData != null ? "stored" : "hardcoded"} data');
    
    // 로드된 모든 책의 정보 출력
    for (var book in books) {
      print('DEBUG: Book ${book.bookNum} - Title: ${book.title}');
    }
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
    _storageService.clearBookData(); // Clear updated book data too
    user.value = null;
    currentCharacter.value = null;
    levelProgress.value = 0.0;
    
    // Reload books to show original hardcoded data
    loadBooks();
    
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

  Future<void> updateBookDatabase() async {
    try {
      Get.snackbar(
        '업데이트',
        '책 데이터를 다운로드하는 중...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Google Sheets CSV URL
      const url = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTz-NZwKCOh2MLmsK-LY12v1c62PithV6gM-EX084CrpF01qnJl48P8zJ7UJCU5kJbZK7BnjZUQm20R/pub?output=csv&gid=0';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        // Parse CSV data
        final csvData = const CsvToListConverter().convert(response.body);
        
        print('DEBUG: CSV 데이터 행 수: ${csvData.length}');
        
        // Group data by BookNum
        final Map<int, Map<String, dynamic>> bookGroups = {};
        
        for (int i = 1; i < csvData.length; i++) {
          final row = csvData[i];
          if (row.length >= 4) {
            final bookNum = int.parse(row[0].toString());
            final title = row[1].toString().trim();
            final word = row[2].toString().trim();
            final sentence = row[3].toString().trim();
            
            // Initialize book group if not exists
            if (!bookGroups.containsKey(bookNum)) {
              bookGroups[bookNum] = {
                'BookNum': bookNum,
                'Title': title,
                'Words': <String>[],
                'Sentences': <String>[],
              };
              print('DEBUG: 새 책 추가 - BookNum: $bookNum, Title: $title');
            } else {
              // 기존 책의 제목이 비어있고 새로운 제목이 있으면 업데이트
              final currentTitle = bookGroups[bookNum]!['Title'] as String;
              if (currentTitle.isEmpty && title.isNotEmpty) {
                bookGroups[bookNum]!['Title'] = title;
                print('DEBUG: 책 제목 업데이트 - BookNum: $bookNum, Title: $title');
              }
            }
            
            // Add word if not empty
            if (word.isNotEmpty) {
              (bookGroups[bookNum]!['Words'] as List<String>).add(word);
            }
            
            // Add sentence if not empty
            if (sentence.isNotEmpty) {
              (bookGroups[bookNum]!['Sentences'] as List<String>).add(sentence);
            }
          }
        }
        
        // Convert to final format and group words
        final bookDataList = <Map<String, dynamic>>[];
        
        print('DEBUG: 총 ${bookGroups.length}개의 책 그룹 발견');
        
        for (final bookData in bookGroups.values) {
          final words = bookData['Words'] as List<String>;
          final sentences = bookData['Sentences'] as List<String>;
          
          // Group words into arrays of 4-5 words each (similar to original data structure)
          final wordGroups = <List<String>>[];
          const wordsPerGroup = 4;
          
          for (int i = 0; i < words.length; i += wordsPerGroup) {
            final endIndex = (i + wordsPerGroup < words.length) ? i + wordsPerGroup : words.length;
            wordGroups.add(words.sublist(i, endIndex));
          }
          
          final bookEntry = {
            'BookNum': bookData['BookNum'],
            'Title': bookData['Title'],
            'Words': wordGroups,
            'Sentences': sentences,
          };
          
          print('DEBUG: 책 데이터 생성 - BookNum: ${bookEntry['BookNum']}, Title: ${bookEntry['Title']}, Words: ${wordGroups.length} groups, Sentences: ${sentences.length}');
          
          bookDataList.add(bookEntry);
        }
        
        // BookNum 순서로 정렬
        bookDataList.sort((a, b) => (a['BookNum'] as int).compareTo(b['BookNum'] as int));
        
        // Save to GetStorage instead of file
        _storageService.saveBookData(bookDataList);
        print('DEBUG: Saved ${bookDataList.length} books to storage');
        
        // Reload books in memory
        loadBooks();
        
        // Force UI update
        update();
        
        Get.snackbar(
          '성공',
          '책 데이터가 업데이트되었습니다. (총 ${bookDataList.length}권)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white,
        );
        
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
      
    } catch (e) {
      Get.snackbar(
        '오류',
        '업데이트 실패: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}