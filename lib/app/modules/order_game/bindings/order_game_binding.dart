import 'package:get/get.dart';
import '../controllers/order_game_controller.dart';

class OrderGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderGameController>(
      () => OrderGameController(),
    );
  }
}