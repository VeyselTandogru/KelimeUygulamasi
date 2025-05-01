import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../models/word_model.dart';
import '../providers/statistics_provider.dart';
import '../services/repeat_words_service.dart';
import '../services/selected_evel_services.dart';
import '../utils/app_constants.dart';
import '../widgets/app_scaffold.dart';

class WordLearnScreen extends StatefulWidget {
  const WordLearnScreen({super.key});

  @override
  State<WordLearnScreen> createState() => _WordLearnScreenState();
}

class _WordLearnScreenState extends State<WordLearnScreen> {
  late String selectedLevel;
  List<Word> words = [];
  bool isLoading = true;
  final CardSwiperController swiperController = CardSwiperController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      selectedLevel = args;
      loadWords();
    } else {
      SelectedLevelService.getSelectedLevel().then((level) {
        if (level != null) {
          setState(() {
            selectedLevel = level;
          });
          loadWords();
        } else {
          Navigator.pop(context);
        }
      });
    }
  }

  Future<void> loadWords() async {
    final String jsonString = await rootBundle.loadString('assets/merged.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    List<Word> allWords = jsonData.map((item) => Word.fromJson(item)).toList();

    words = allWords.where((word) => word.level == selectedLevel).toList();

    if (words.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Kelimeler Bulunamadı'),
          content: const Text('Bu seviyeye ait kelime bulunamadı.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  bool handleSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (previousIndex >= words.length) return true;

    final currentWord = words[previousIndex];

    if (direction == CardSwiperDirection.right) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bu kelime zaten biliniyor!")),
      );
    } else if (direction == CardSwiperDirection.left) {
      Provider.of<StatisticsProvider>(context, listen: false)
          .incrementLearnedWordCount();
      RepeatWordsService.addWord(currentWord);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kelime öğrenilecekler listesine eklendi!"),
        ),
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AppScaffold(
      title: 'Kelime Öğren',
      currentIndex: 1,
      body: CardSwiper(
        cardsCount: words.length,
        numberOfCardsDisplayed: words.length >= 3 ? 3 : words.length,
        controller: swiperController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        onSwipe: handleSwipe,
        cardBuilder: (context, index, percentX, percentY) {
          final word = words[index];
          final textTheme = Theme.of(context).textTheme;

          return Center(
            // 🔽 dikeyde ortalamayı sağlar
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height *
                  0.72, // 🔽 sabit yükseklik
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: AppConstants.paddingAllMedium,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Kategori ve Seviye
                              Row(
                                children: [
                                  Checkbox(
                                    value: false,
                                    onChanged: (_) {},
                                    activeColor: AppConstants.primaryColor,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${word.level}',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppConstants.subtitleDarkColor
                                            : AppConstants.subtitleLightColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Kelime ve Dil Bilgisi
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      word.word, // İngilizce kelime: "About"
                                      style: textTheme.headlineLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      word.partOfSpeech, // İngilizce dil bilgisi: "preposition"
                                      style: textTheme.bodyMedium
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Türkçe karşılık
                              Text('Türkçesi', style: textTheme.titleLarge),
                              const SizedBox(height: 4),
                              Text(word.translation,
                                  style: textTheme.bodyLarge),

                              const SizedBox(height: 12),

                              // Türkçe dil bilgisi açıklaması
                              Text('Türkçe Dil Bilgisi',
                                  style: textTheme.titleLarge),
                              const SizedBox(height: 4),
                              Text(word.meaning, style: textTheme.bodyLarge),

                              const SizedBox(height: 12),

                              // İngilizce örnekler
                              Text('İngilizce Örnekler',
                                  style: textTheme.titleLarge),
                              const SizedBox(height: 4),
                              ...word.examples.map(
                                (example) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child:
                                      Text(example, style: textTheme.bodyLarge),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Türkçe örnekler
                              Text('Türkçe Örnekler',
                                  style: textTheme.titleLarge),
                              const SizedBox(height: 4),
                              ...word.turkishExamples.map(
                                (example) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child:
                                      Text(example, style: textTheme.bodyLarge),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
