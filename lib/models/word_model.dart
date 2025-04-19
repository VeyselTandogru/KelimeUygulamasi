class Word {
  final String word;
  final String pronunciation;
  final String partOfSpeech;
  final String meaning;
  final String translation;
  final List<String> examples;
  final String category;
  final bool isLearned;

  Word({
    required this.word,
    required this.pronunciation,
    required this.partOfSpeech,
    required this.meaning,
    required this.translation,
    required this.examples,
    this.category = '',
    this.isLearned = false,
  });
}
