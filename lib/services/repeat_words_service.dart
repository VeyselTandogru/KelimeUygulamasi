import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_model.dart';

class RepeatWordsService {
  static const _key = 'repeat_words';

  static List<Word> _repeatWords = [];

  static List<Word> get repeatWords => _repeatWords;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];

    _repeatWords = jsonList
        .map((jsonStr) => Word.fromJson(json.decode(jsonStr)))
        .toList();
  }

  static Future<void> addWord(Word word) async {
    if (!_repeatWords.any((w) => w.word == word.word)) {
      word.addedDate = DateTime.now();
      word.repeatStep = 0;
      _repeatWords.add(word);
      await _saveToStorage();
    }
  }

  static Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _repeatWords.map((w) => json.encode(w.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<void> clearWords() async {
    _repeatWords.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<void> updateWord(Word updatedWord) async {
    final index = _repeatWords.indexWhere((w) => w.word == updatedWord.word);
    if (index != -1) {
      _repeatWords[index] = updatedWord;
      await _saveToStorage();
    }
  }

  static Future<void> deleteWord(Word word) async {
    _repeatWords.removeWhere((w) => w.word == word.word);
    await _saveToStorage();
  }
}