import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class WordRepeatScreen extends StatefulWidget {
  const WordRepeatScreen({super.key});

  @override
  State<WordRepeatScreen> createState() => _WordRepeatScreenState();
}

class _WordRepeatScreenState extends State<WordRepeatScreen> {
  // Örnek tekrar edilecek kelimeler
  final List<Map<String, dynamic>> words = [
    {'english': 'apple', 'turkish': 'elma', 'isRevealed': false},
    {'english': 'book', 'turkish': 'kitap', 'isRevealed': false},
    {'english': 'car', 'turkish': 'araba', 'isRevealed': false},
    {'english': 'house', 'turkish': 'ev', 'isRevealed': false},
    {'english': 'computer', 'turkish': 'bilgisayar', 'isRevealed': false},
  ];

  int currentIndex = 0;
  bool isAnswerRevealed = false;

  void revealAnswer() {
    setState(() {
      isAnswerRevealed = true;
      words[currentIndex]['isRevealed'] = true;
    });
  }

  void nextWord() {
    if (currentIndex < words.length - 1) {
      setState(() {
        currentIndex++;
        isAnswerRevealed = false;
      });
    } else {
      // Son kelimeye ulaşıldı, tüm kelimeleri tekrar et
      showCompletionDialog();
    }
  }

  void previousWord() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isAnswerRevealed = words[currentIndex]['isRevealed'];
      });
    }
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
                Navigator.of(context).pop(); // Ana sayfaya dön
              },
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
        );
      },
    );
  }

  void resetWords() {
    setState(() {
      for (var word in words) {
        word['isRevealed'] = false;
      }
      currentIndex = 0;
      isAnswerRevealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = words[currentIndex];
    return Scaffold(
      appBar: AppBar(title: const Text('Kelime Tekrarı')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // İlerleme göstergesi
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Kelime ${currentIndex + 1}/${words.length}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            LinearProgressIndicator(
              value: (currentIndex + 1) / words.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 32),

            // Kelime kartı
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'İngilizce',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentWord['english'],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Türkçe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (isAnswerRevealed)
                        Text(
                          currentWord['turkish'],
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        ElevatedButton(
                          onPressed: revealAnswer,
                          child: const Text('Cevabı Göster'),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Navigasyon butonları
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
}
