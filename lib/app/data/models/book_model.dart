class BookModel {
  final int bookNum;
  final String title;
  final List<List<String>> words;
  final List<String> sentences;

  BookModel({
    required this.bookNum,
    required this.title,
    required this.words,
    required this.sentences,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    // 데이터 검증 추가
    final bookNum = json['BookNum'] ?? 0;
    final title = json['Title'] ?? '';
    
    // 디버그 로그
    print('BookModel.fromJson - BookNum: $bookNum, Title: $title');
    
    // 제목이 비어있거나 잘못된 경우 기본값 설정
    final validatedTitle = (title.isEmpty || title == 'null') 
        ? 'Book $bookNum' 
        : title;
    
    return BookModel(
      bookNum: bookNum,
      title: validatedTitle,
      words: _parseWords(json['Words']),
      sentences: List<String>.from(json['Sentences'] ?? []),
    );
  }

  static List<List<String>> _parseWords(dynamic data) {
    if (data == null) return [];
    
    final List<List<String>> result = [];
    
    if (data is List) {
      for (var wordGroup in data) {
        if (wordGroup is List) {
          result.add(List<String>.from(wordGroup));
        }
      }
    }
    
    return result;
  }

  List<String> get allWords {
    final List<String> allWords = [];
    for (var wordGroup in words) {
      allWords.addAll(wordGroup);
    }
    return allWords;
  }
}