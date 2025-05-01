import 'package:shared_preferences/shared_preferences.dart';

class SelectedLevelService {
  static const String _selectedLevelKey = 'selected_level';

  static Future<void> setSelectedLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLevelKey, level);
  }

  static Future<String?> getSelectedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedLevelKey);
  }

  static Future<void> clearSelectedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedLevelKey);
  }
}