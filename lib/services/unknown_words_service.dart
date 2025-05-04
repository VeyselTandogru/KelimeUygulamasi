import 'package:shared_preferences/shared_preferences.dart';

class UnknownWordsService {
  static const _key = 'unknown_words';

  static Future<void> markAsUnknown(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final unknown = prefs.getStringList(_key) ?? [];
    if (!unknown.contains(word)) {
      unknown.add(word);
      await prefs.setStringList(_key, unknown);
    }
  }

  static Future<List<String>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}