import 'package:flutter/foundation.dart';
import '../models/statistics_model.dart';
import '../services/statistics_service.dart';

class StatisticsProvider with ChangeNotifier {
  Statistics? _statistics;
  final StatisticsService _service = StatisticsService();
  bool _isLoading = true;

  // Getter metotları
  Statistics get statistics => _statistics ?? Statistics.defaultStats();
  bool get isLoading => _isLoading;

  // Constructor - hemen verileri yükle
  StatisticsProvider() {
    loadStatistics();
  }

  // İstatistikleri yükle
  Future<void> loadStatistics() async {
    _isLoading = true;
    notifyListeners();

    // Önce son kullanım tarihini kontrol et ve gerekirse günlük verileri sıfırla
    _statistics = await _service.checkDailyReset();

    _isLoading = false;
    notifyListeners();
  }

  // Bugün öğrenilen kelime sayısını artır
  Future<void> incrementLearnedWordCount() async {
    _statistics = await _service.incrementLearnedToday();
    notifyListeners();
  }

  // Günlük hedefi güncelle
  Future<void> updateDailyGoal(int newGoal) async {
    _statistics = await _service.updateDailyGoal(newGoal);
    notifyListeners();
  }
}
