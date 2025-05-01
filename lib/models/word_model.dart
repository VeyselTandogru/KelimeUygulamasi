class Word {
  final String word; // kelime
  final String translation; // turkceKelime
  final String partOfSpeech; // dil_bilgisi (İngilizce açıklama)
  final String meaning; // turkceDilBilgisi (Türkçe açıklama)
  final List<String> examples; // örnekler (İngilizce cümleler)
  final List<String> turkishExamples; // turkceÖrnekler
  final String category; // kategori (İngilizce)
  final String level; // turkceKategori

  bool isRevealed;
  DateTime addedDate;
  int repeatStep;

  Word({
    required this.word,
    required this.translation,
    required this.partOfSpeech,
    required this.meaning,
    required this.examples,
    required this.turkishExamples,
    required this.category,
    required this.level,
    this.isRevealed = false,
    DateTime? addedDate,
    this.repeatStep = 0,
  }) : addedDate = addedDate ?? DateTime.now();

  factory Word.fromJson(Map<String, dynamic> json) {
  return Word(
    word: json['kelime'] ?? '',
    translation: json['turkceKelime'] ?? '',
    partOfSpeech: json['dil_bilgisi'] ?? '',
    meaning: json['turkceDilBilgisi'] ?? '',
    examples: List<String>.from(json['örnekler'] ?? []),
    turkishExamples: List<String>.from(json['turkceÖrnekler'] ?? []),
    category: json['kategori'] ?? '',
    level: json['turkceKategori'] ?? '',
  );
}

  Map<String, dynamic> toJson() {
    return {
      'kelime': word,
      'turkceKelime': translation,
      'dil_bilgisi': partOfSpeech,
      'turkceDilBilgisi': meaning,
      'örnekler': examples,
      'turkceÖrnekler': turkishExamples,
      'kategori': category,
      'turkceKategori': level,
      'addedDate': addedDate.toIso8601String(),
      'repeatStep': repeatStep,
    };
  }
}