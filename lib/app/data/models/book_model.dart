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
    return BookModel(
      bookNum: json['BookNum'] ?? 0,
      title: json['Title'] ?? '',
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