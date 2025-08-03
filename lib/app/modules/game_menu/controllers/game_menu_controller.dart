import 'package:get/get.dart';
import '../../../data/models/book_model.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/storage_service.dart';
import '../../../modules/home/controllers/home_controller.dart';
import '../../../../bookData/bookData.dart';

class GameMenuController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final RxInt bookNum = 0.obs;
  final Rx<BookModel?> currentBook = Rx<BookModel?>(null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['bookNum'] != null) {
      bookNum.value = args['bookNum'];
      loadBook();
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Listen for changes when returning from games
    ever(Get.find<HomeController>().user, (_) => update());
  }
  

  void loadBook() {
    final bookDataItem = bookData.firstWhere(
      (book) => book['BookNum'] == bookNum.value,
      orElse: () => bookData.first,
    );
    currentBook.value = BookModel.fromJson(bookDataItem);
  }

  void navigateToWordGame() {
    Get.toNamed(
      Routes.WORD_GAME,
      arguments: {'book': currentBook.value},
    );
  }

  void navigateToSentenceGame() {
    Get.toNamed(
      Routes.SENTENCE_GAME,
      arguments: {'book': currentBook.value},
    );
  }

  void navigateToOrderGame() {
    Get.toNamed(
      Routes.ORDER_GAME,
      arguments: {'book': currentBook.value},
    );
  }

  void goBack() {
    Get.back();
  }

  int getCompletionCount(String gameType) {
    final user = _storageService.getUserData();
    if (user == null || currentBook.value == null) {
      print('DEBUG: user or currentBook is null');
      return 0;
    }
    
    final bookKey = currentBook.value!.bookNum.toString();
    final count = user.completionCounts[bookKey]?[gameType] ?? 0;
    print('DEBUG: bookKey=$bookKey, gameType=$gameType, count=$count');
    print('DEBUG: completionCounts=${user.completionCounts}');
    return count;
  }

  void refreshCompletionCounts() {
    update(); // Force UI update
  }
}