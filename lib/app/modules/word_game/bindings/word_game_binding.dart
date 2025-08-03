import 'package:get/get.dart';
import '../controllers/word_game_controller.dart';

class WordGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordGameController>(
      () => WordGameController(),
    );
  }
}