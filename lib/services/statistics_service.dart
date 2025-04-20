import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/statistics_model.dart';

class StatisticsService {
  static const String _statsKey = 'user_statistics';

  // Singleton yapısı
  static final StatisticsService _instance = StatisticsService._internal();
  factory StatisticsService() => _instance;
  StatisticsService._internal();

  // İstatistikleri almak
  Future<Statistics> getStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    final statsString = prefs.getString(_statsKey);

    if (statsString == null) {
      // İlk çalıştırma ise varsayılan istatistikleri döndür
      return Statistics.defaultStats();
    }

    try {
      final statsJson = jsonDecode(statsString);
      return Statistics.fromJson(statsJson);
    } catch (e) {
      print('İstatistik verileri çözülürken hata oluştu: $e');
      return Statistics.defaultStats();
    }
  }

  // İstatistikleri kaydetmek
  Future<bool> saveStatistics(Statistics statistics) async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = jsonEncode(statistics.toJson());

    return await prefs.setString(_statsKey, statsJson);
  }

  // Bugün öğrenilen kelime sayısını artırmak
  Future<Statistics> incrementLearnedToday() async {
    final currentStats = await getStatistics();
    final learnedToday = currentStats.learnedToday + 1;
    final totalLearnedWords = currentStats.totalLearnedWords + 1;

    // Haftanın gününü belirle
    final now = DateTime.now();
    final weekday = now.weekday; // 1 = Pazartesi, 7 = Pazar

    String dayKey;
    switch (weekday) {
      case 1:
        dayKey = 'Pzt';
        break;
      case 2:
        dayKey = 'Sal';
        break;
      case 3:
        dayKey = 'Çar';
        break;
      case 4:
        dayKey = 'Per';
        break;
      case 5:
        dayKey = 'Cum';
        break;
      case 6:
        dayKey = 'Cmt';
        break;
      case 7:
        dayKey = 'Paz';
        break;
      default:
        dayKey = 'Pzt';
    }

    // Haftalık istatistiği güncelle
    final Map<String, double> weeklyProgress = Map<String, double>.from(
      currentStats.weeklyProgress,
    );
    // Mevcut değeri alıp 1 arttır
    double currentValue = weeklyProgress[dayKey] ?? 0;
    weeklyProgress[dayKey] = currentValue + 1;

    // Yeni istatistik nesnesini oluştur
    final updatedStats = currentStats.copyWith(
      learnedToday: learnedToday,
      totalLearnedWords: totalLearnedWords,
      weeklyProgress: weeklyProgress,
    );

    // Verileri kaydet
    await saveStatistics(updatedStats);
    return updatedStats;
  }

  // Günlük hedefi güncelle
  Future<Statistics> updateDailyGoal(int newGoal) async {
    final currentStats = await getStatistics();
    final updatedStats = currentStats.copyWith(dailyGoal: newGoal);

    await saveStatistics(updatedStats);
    return updatedStats;
  }

  // Günlük istatistikleri sıfırla ve seriyi güncelle
  Future<Statistics> resetDailyStats() async {
    final currentStats = await getStatistics();

    // Dün öğrenilen kelime varsa seriyi artır, yoksa sıfırla
    int newStreakDays =
        currentStats.learnedToday > 0 ? currentStats.streakDays + 1 : 0;

    final updatedStats = currentStats.copyWith(
      learnedToday: 0,
      streakDays: newStreakDays,
    );

    await saveStatistics(updatedStats);
    return updatedStats;
  }

  // Uygulama başlatıldığında günlük istatistikleri kontrol et ve güncelle
  Future<Statistics> checkDailyReset() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString('last_usage_date');
    final today =
        DateTime.now().toIso8601String().split(
          'T',
        )[0]; // Sadece tarih kısmını al

    if (lastDate != today) {
      // Yeni gün, istatistikleri sıfırla
      await prefs.setString('last_usage_date', today);
      return await resetDailyStats();
    }

    // Aynı gün
    await prefs.setString('last_usage_date', today);
    return await getStatistics();
  }
}
