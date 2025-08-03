import 'package:get/get.dart';
import '../../../data/models/book_model.dart';
import '../../../routes/app_routes.dart';
import '../../../../bookData/bookData.dart';

class GameMenuController extends GetxController {
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
}