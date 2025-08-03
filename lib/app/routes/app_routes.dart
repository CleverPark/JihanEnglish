abstract class Routes {
  Routes._();

  static const WELCOME = _Paths.WELCOME;
  static const HOME = _Paths.HOME;
  static const GAME_MENU = _Paths.GAME_MENU;
  static const WORD_GAME = _Paths.WORD_GAME;
  static const SENTENCE_GAME = _Paths.SENTENCE_GAME;
  static const ORDER_GAME = _Paths.ORDER_GAME;
}

abstract class _Paths {
  _Paths._();

  static const WELCOME = '/welcome';
  static const HOME = '/home';
  static const GAME_MENU = '/game-menu';
  static const WORD_GAME = '/word-game';
  static const SENTENCE_GAME = '/sentence-game';
  static const ORDER_GAME = '/order-game';
}