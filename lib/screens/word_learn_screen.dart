import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/word_model.dart';
import '../utils/app_constants.dart';
import '../providers/statistics_provider.dart';

class WordLearnScreen extends StatefulWidget {
  const WordLearnScreen({super.key});

  @override
  State<WordLearnScreen> createState() => _WordLearnScreenState();
}

class _WordLearnScreenState extends State<WordLearnScreen> {
  // Örnek bir kelime
  late Word currentWord;

  @override
  void initState() {
    super.initState();
    // Örnek veri
    currentWord = Word(
      word: 'ability',
      pronunciation: '/əˈbɪləti/',
      partOfSpeech: 'NOUN',
      meaning:
          'ability to do something the fact that somebody/something is able to do something',
      translation:
          'bir şeyi yapabilme yeteneği, birisinin/bir şeyin bir şeyi yapma yeteneği',
      examples: [
        'People with the disease may lose their ability to communicate.',
        'This program has the ability to adapt to its user.',
        'Students must demonstrate the ability to understand simple texts.',
        'She has an uncanny ability to predict what consumers will want.',
        'A gentle form of exercise will increase your ability to relax.',
      ],
      category: 'Oxford 5000 - A2',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Kelime Öğren')),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppConstants.paddingAllMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kelime kategorisi
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (_) {},
                    activeColor: AppConstants.primaryColor,
                  ),
                  Text(
                    currentWord.category,
                    style: textTheme.bodyMedium?.copyWith(
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppConstants.subtitleDarkColor
                              : AppConstants.subtitleLightColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.paddingMedium),

              // Kelime ve telaffuz
              Center(
                child: Column(
                  children: [
                    Text(currentWord.word, style: textTheme.headlineLarge),
                    SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      currentWord.pronunciation,
                      style: textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppConstants.subtitleDarkColor
                                : AppConstants.subtitleLightColor,
                      ),
                    ),
                    SizedBox(height: AppConstants.paddingSmall / 2),
                    Text(
                      currentWord.partOfSpeech,
                      style: textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppConstants.subtitleDarkColor
                                : AppConstants.subtitleLightColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppConstants.paddingLarge),

              // Anlam
              Text(
                'Anlamı',
                style: textTheme.titleLarge?.copyWith(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppConstants.subtitleDarkColor
                          : AppConstants.subtitleLightColor,
                ),
              ),
              SizedBox(height: AppConstants.paddingSmall / 2),
              Text(currentWord.meaning, style: textTheme.bodyLarge),

              SizedBox(height: AppConstants.paddingMedium),

              // Çevirisi
              Text(
                'Çevirisi',
                style: textTheme.titleLarge?.copyWith(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppConstants.subtitleDarkColor
                          : AppConstants.subtitleLightColor,
                ),
              ),
              SizedBox(height: AppConstants.paddingSmall / 2),
              Text(currentWord.translation, style: textTheme.bodyLarge),

              SizedBox(height: AppConstants.paddingLarge),

              // Örnek Cümleler
              Text(
                'Örnek Cümleler',
                style: textTheme.titleLarge?.copyWith(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppConstants.subtitleDarkColor
                          : AppConstants.subtitleLightColor,
                ),
              ),
              SizedBox(height: AppConstants.paddingSmall),
              ...currentWord.examples.map(
                (example) => Padding(
                  padding: EdgeInsets.only(bottom: AppConstants.paddingSmall),
                  child: Text(example, style: textTheme.bodyLarge),
                ),
              ),

              SizedBox(height: AppConstants.paddingXLarge),

              // Alt butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Bunu zaten biliyorum'),
                      onPressed: () {
                        // İşlem
                      },
                    ),
                  ),
                  SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Bunu öğrenmeliyim'),
                      onPressed: () {
                        // İstatistikleri güncelle
                        Provider.of<StatisticsProvider>(
                          context,
                          listen: false,
                        ).incrementLearnedWordCount();

                        // Kullanıcıya bilgi mesajı göster
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Kelime öğrenildi ve istatistikleriniz güncellendi!',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // Sonraki kelimeye geçmek için burada ekstra bir şey yapılabilir
                        // Şimdilik aynı kelimeyle devam ediyoruz
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
