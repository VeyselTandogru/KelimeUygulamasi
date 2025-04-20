class Statistics {
  final int dailyGoal;
  final int learnedToday;
  final int streakDays;
  final int totalLearnedWords;
  final Map<String, double> weeklyProgress;

  Statistics({
    required this.dailyGoal,
    required this.learnedToday,
    required this.streakDays,
    required this.totalLearnedWords,
    required this.weeklyProgress,
  });

  Statistics copyWith({
    int? dailyGoal,
    int? learnedToday,
    int? streakDays,
    int? totalLearnedWords,
    Map<String, double>? weeklyProgress,
  }) {
    return Statistics(
      dailyGoal: dailyGoal ?? this.dailyGoal,
      learnedToday: learnedToday ?? this.learnedToday,
      streakDays: streakDays ?? this.streakDays,
      totalLearnedWords: totalLearnedWords ?? this.totalLearnedWords,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
    );
  }

  // JSON dönüşümleri için metodlar
  Map<String, dynamic> toJson() {
    return {
      'dailyGoal': dailyGoal,
      'learnedToday': learnedToday,
      'streakDays': streakDays,
      'totalLearnedWords': totalLearnedWords,
      'weeklyProgress': weeklyProgress,
    };
  }

  factory Statistics.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> weeklyMap = json['weeklyProgress'] ?? {};
    Map<String, double> weeklyProgressMap = {};

    weeklyMap.forEach((key, value) {
      weeklyProgressMap[key] = (value as num).toDouble();
    });

    return Statistics(
      dailyGoal: json['dailyGoal'] ?? 5,
      learnedToday: json['learnedToday'] ?? 0,
      streakDays: json['streakDays'] ?? 0,
      totalLearnedWords: json['totalLearnedWords'] ?? 0,
      weeklyProgress: weeklyProgressMap,
    );
  }

  // Varsayılan değerlerle bir istatistik nesnesi oluşturmak için factory metodu
  factory Statistics.defaultStats() {
    return Statistics(
      dailyGoal: 5,
      learnedToday: 0,
      streakDays: 0,
      totalLearnedWords: 0,
      weeklyProgress: {
        'Pzt': 0.0,
        'Sal': 0.0,
        'Çar': 0.0,
        'Per': 0.0,
        'Cum': 0.0,
        'Cmt': 0.0,
        'Paz': 0.0,
      },
    );
  }
}
