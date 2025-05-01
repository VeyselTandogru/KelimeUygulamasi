import '../models/word_model.dart';

class RepeatWordsService {
  static final List<Word> _repeatWords = [];

  static List<Word> get repeatWords => _repeatWords;

  static void addWord(Word word) {
    if (!_repeatWords.any((w) => w.word == word.word)) {
      word.addedDate = DateTime.now();
      word.repeatStep = 0;
      _repeatWords.add(word);
    }
  }

  static void clearWords() {
    _repeatWords.clear();
  }
}