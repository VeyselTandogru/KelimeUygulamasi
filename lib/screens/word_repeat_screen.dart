import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../routes/app_routes.dart';
import '../services/repeat_words_service.dart'; // <<< Bunu ekledik
import '../models/word_model.dart'; // <<< Bunu ekledik
import '../widgets/app_scaffold.dart';

class WordRepeatScreen extends StatefulWidget {
  const WordRepeatScreen({super.key});

  @override
  State<WordRepeatScreen> createState() => _WordRepeatScreenState();
}

class _WordRepeatScreenState extends State<WordRepeatScreen> {
  late List<Word> repeatWords;
  int currentIndex = 0;
  bool isAnswerRevealed = false;

  @override
  void initState() {
    super.initState();

    List<int> repeatDays = [0, 1, 2, 4, 7, 14, 30];

    repeatWords = RepeatWordsService.repeatWords.where((word) {
      if (word.repeatStep >= repeatDays.length) {
        return false;
      }

      final addedDate = word.addedDate;
      final daysSinceAdded = DateTime.now().difference(addedDate).inDays;
      return daysSinceAdded >= repeatDays[word.repeatStep];
    }).toList();

    if (repeatWords.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showNoWordsDialog();
      });
    }
  }

  void revealAnswer() {
    setState(() {
      isAnswerRevealed = true;
    });
  }

  void nextWord() async {
    final word = repeatWords[currentIndex];
    word.repeatStep += 1;
    word.addedDate = DateTime.now();

    const repeatDays = [0, 1, 2, 4, 7, 14, 30];

    if (word.repeatStep >= repeatDays.length) {
      await RepeatWordsService.deleteWord(word);
    } else {
      await RepeatWordsService.updateWord(word);
    }
    if (currentIndex < repeatWords.length - 1) {
      setState(() {
        currentIndex++;
        isAnswerRevealed = false;
      });
    } else {
      showCompletionDialog();
    }
  }

  void previousWord() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isAnswerRevealed = repeatWords[currentIndex].isRevealed ?? false;
      });
    }
  }

  void resetWords() {
    setState(() {
      currentIndex = 0;
      isAnswerRevealed = false;
    });
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tebrikler!'),
          content: const Text('Tüm kelimeleri tekrar ettiniz.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetWords();
              },
              child: const Text('Tekrar Başla'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
        );
      },
    );
  }

  void showNoWordsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tekrar Edilecek Kelime Yok'),
          content: const Text('Henüz "Bilmiyorum" dediğiniz kelime yok.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (repeatWords.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentWord = repeatWords[currentIndex];

    return AppScaffold(
      title: 'Kelime Tekrarı',
      currentIndex: 2,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // İlerleme göstergesi
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Kelime ${currentIndex + 1}/${repeatWords.length}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            LinearProgressIndicator(
              value: (currentIndex + 1) / repeatWords.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 32),

            Expanded(
              child: GestureDetector(
                onTap: isAnswerRevealed ? null : revealAnswer,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(
                      begin: 0, end: isAnswerRevealed ? 1.0 : 0.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    final isUnder = value > 0.5;
                    final rotationY = value * 3.1416; 

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(rotationY),
                      child: isUnder
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(3.1416),
                              child: _buildBackCard(currentWord.translation),
                            )
                          : _buildFrontCard(currentWord.word),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: currentIndex > 0 ? previousWord : null,
                  iconSize: 32,
                  color: currentIndex > 0 ? AppColors.primary : Colors.grey,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: isAnswerRevealed ? nextWord : null,
                  iconSize: 32,
                  color: isAnswerRevealed ? AppColors.primary : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildFrontCard(String word) {
    final current = repeatWords[currentIndex];

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  word,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                '📘 Gramer Türü',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                current.partOfSpeech,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              Text(
                '📝 İngilizce Örnekler',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 6),
              ...current.examples.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• $e',
                    style: const TextStyle(fontSize: 16, color: Colors.black87)),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard(String translation) {
    final current = repeatWords[currentIndex];

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  translation,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                '📖 Açıklama',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                current.meaning,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              Text(
                '🇹🇷 Türkçe Örnekler',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 6),
              ...current.turkishExamples.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• $e',
                    style: const TextStyle(fontSize: 16, color: Colors.black87)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

