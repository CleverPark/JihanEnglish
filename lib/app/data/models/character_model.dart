class CharacterModel {
  final String levelRange;
  final String title;
  final String imagePath;

  CharacterModel({
    required this.levelRange,
    required this.title,
    required this.imagePath,
  });

  static List<CharacterModel> getCharacters() {
    return [
      CharacterModel(
        levelRange: '1-20',
        title: '견습 용사',
        imagePath: 'lib/assets/worriorImg/tempWorrior.png',
      ),
      CharacterModel(
        levelRange: '21-40',
        title: '초급 기사',
        imagePath: 'lib/assets/worriorImg/tempWorrior.png',
      ),
      CharacterModel(
        levelRange: '41-60',
        title: '중급 전사',
        imagePath: 'lib/assets/worriorImg/tempWorrior.png',
      ),
      CharacterModel(
        levelRange: '61-80',
        title: '상급 마법사',
        imagePath: 'lib/assets/worriorImg/tempWorrior.png',
      ),
      CharacterModel(
        levelRange: '81-100',
        title: '전설의 영웅',
        imagePath: 'lib/assets/worriorImg/tempWorrior.png',
      ),
    ];
  }

  static CharacterModel getCharacterByLevel(int level) {
    final characters = getCharacters();
    
    if (level <= 20) return characters[0];
    if (level <= 40) return characters[1];
    if (level <= 60) return characters[2];
    if (level <= 80) return characters[3];
    return characters[4];
  }
}