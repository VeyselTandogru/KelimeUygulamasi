import 'package:shared_preferences/shared_preferences.dart';

class KnownWordsService {
  static const _key = 'known_words';

  static Future<void> markAsKnown(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final known = prefs.getStringList(_key) ?? [];
    if (!known.contains(word)) {
      known.add(word);
      await prefs.setStringList(_key, known);
    }
  }

  static Future<bool> isKnown(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final known = prefs.getStringList(_key) ?? [];
    return known.contains(word);
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