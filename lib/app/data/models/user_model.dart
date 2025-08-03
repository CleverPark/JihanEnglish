class UserModel {
  final String userName;
  final int level;
  final int currentExp;
  final int requiredExp;
  final String characterType;
  final Map<String, Map<String, bool>> completedBooks;
  final DateTime lastPlayed;

  UserModel({
    required this.userName,
    required this.level,
    required this.currentExp,
    required this.requiredExp,
    required this.characterType,
    required this.completedBooks,
    required this.lastPlayed,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'] ?? '',
      level: json['level'] ?? 1,
      currentExp: json['currentExp'] ?? 0,
      requiredExp: json['requiredExp'] ?? 100,
      characterType: json['characterType'] ?? 'warrior',
      completedBooks: _parseCompletedBooks(json['completedBooks']),
      lastPlayed: DateTime.parse(json['lastPlayed'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'level': level,
      'currentExp': currentExp,
      'requiredExp': requiredExp,
      'characterType': characterType,
      'completedBooks': completedBooks,
      'lastPlayed': lastPlayed.toIso8601String(),
    };
  }

  static Map<String, Map<String, bool>> _parseCompletedBooks(dynamic data) {
    if (data == null) return {};
    
    final Map<String, Map<String, bool>> result = {};
    
    if (data is Map) {
      data.forEach((key, value) {
        if (value is Map) {
          result[key.toString()] = Map<String, bool>.from(value);
        }
      });
    }
    
    return result;
  }

  UserModel copyWith({
    String? userName,
    int? level,
    int? currentExp,
    int? requiredExp,
    String? characterType,
    Map<String, Map<String, bool>>? completedBooks,
    DateTime? lastPlayed,
  }) {
    return UserModel(
      userName: userName ?? this.userName,
      level: level ?? this.level,
      currentExp: currentExp ?? this.currentExp,
      requiredExp: requiredExp ?? this.requiredExp,
      characterType: characterType ?? this.characterType,
      completedBooks: completedBooks ?? this.completedBooks,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }
}