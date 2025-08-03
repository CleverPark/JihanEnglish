import 'package:get/get.dart';

import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/game_menu/bindings/game_menu_binding.dart';
import '../modules/game_menu/views/game_menu_view.dart';
import '../modules/word_game/bindings/word_game_binding.dart';
import '../modules/word_game/views/word_game_view.dart';
import '../modules/sentence_game/bindings/sentence_game_binding.dart';
import '../modules/sentence_game/views/sentence_game_view.dart';
import '../modules/order_game/bindings/order_game_binding.dart';
import '../modules/order_game/views/order_game_view.dart';

import 'app_routes.dart';

abstract class _Paths {
  _Paths._();

  static const WELCOME = '/welcome';
  static const HOME = '/home';
  static const GAME_MENU = '/game-menu';
  static const WORD_GAME = '/word-game';
  static const SENTENCE_GAME = '/sentence-game';
  static const ORDER_GAME = '/order-game';
}

class AppPages {
  AppPages._();

  static const INITIAL = Routes.WELCOME;

  static final routes = [
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.GAME_MENU,
      page: () => const GameMenuView(),
      binding: GameMenuBinding(),
    ),
    GetPage(
      name: _Paths.WORD_GAME,
      page: () => const WordGameView(),
      binding: WordGameBinding(),
    ),
    GetPage(
      name: _Paths.SENTENCE_GAME,
      page: () => const SentenceGameView(),
      binding: SentenceGameBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_GAME,
      page: () => const OrderGameView(),
      binding: OrderGameBinding(),
    ),
  ];
}