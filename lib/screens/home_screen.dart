import 'package:flutter/material.dart';
import 'package:ingilizce_ogrenme_uygulamasi/screens/word_learn_screen.dart';
import '../utils/app_colors.dart';
import '../screens/word_repeat_screen.dart';
import '../screens/word_categories_screen.dart';
import '../main.dart'; // NavigationUtil'i içe aktaralım

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int dailyGoal = 5;
  final int completedToday = 5;
  final int daysStreak = 13;
  final int totalWords = 67;

  final Map<String, double> weeklyProgress = {
    'Pzt': 2.0,
    'Sal': 3.8,
    'Çar': 2.5,
    'Per': 5.0,
    'Cum': 3.6,
    'Cmt': 1.0,
    'Paz': 0.0,
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Ana Sayfa')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menü kartları
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      'Kelime Grupları',
                      Icons.layers,
                      onTap: () {
                        // Alt navigasyon çubuğunu göstererek Kelime Grupları sayfasına git
                        NavigationUtil.navigateWithBottomBar(
                          context,
                          const WordCategoriesScreen(),
                          selectedTab: 0, // Home sekmesi seçili olsun
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      'Yeni Kelime Öğren',
                      Icons.add_circle_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WordLearnScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      'Kelimeleri Tekrarla',
                      Icons.refresh,
                      onTap: () {
                        // Kelime tekrar sayfasına git
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WordRepeatScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24.0),

              // Haftalık İstatistik Grafiği
              Text('Haftalık İstatistik', style: textTheme.titleLarge),
              const SizedBox(height: 8.0),
              SizedBox(height: 200, child: _buildWeeklyChart(isDark)),

              const SizedBox(height: 24.0),

              // İstatistik kartları
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard(
                            'Bugün Öğrenilen',
                            '$completedToday/$dailyGoal',
                          ),
                          const VerticalDivider(width: 1),
                          _buildStatCard('Toplam Seri 🔥', '$daysStreak gün'),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            'Toplam Öğrenilen Kelime : ',
                            style: textTheme.bodyLarge,
                          ),
                          Text(
                            '$totalWords kelime',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 24.0),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      onTap: onTap,
    );
  }

  Widget _buildStatCard(String title, String value) {
    final textTheme = Theme.of(context).textTheme;
    final subtitleColor =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.textDarkSubtitle
            : AppColors.textLightSubtitle;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(color: subtitleColor),
          ),
          const SizedBox(height: 8.0),
          Text(value, style: textTheme.headlineMedium),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children:
          weeklyProgress.entries.map((entry) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: entry.value * 30, // Yüksekliği değere göre ayarla
                    width: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors:
                            isDark
                                ? [
                                  AppColors.primary,
                                  const Color.fromARGB(255, 255, 255, 255),
                                ]
                                : [
                                  const Color.fromARGB(255, 0, 0, 0),
                                  AppColors.primary,
                                ],
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(entry.key, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            );
          }).toList(),
    );
  }
}
