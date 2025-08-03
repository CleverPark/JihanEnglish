import 'package:get/get.dart';
import '../controllers/sentence_game_controller.dart';

class SentenceGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SentenceGameController>(
      () => SentenceGameController(),
    );
  }
}