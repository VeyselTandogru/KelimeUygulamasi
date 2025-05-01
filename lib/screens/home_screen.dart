import 'package:flutter/material.dart';
import 'package:ingilizce_ogrenme_uygulamasi/providers/statistics_provider.dart';
import 'package:provider/provider.dart';
import '../services/selected_evel_services.dart';
import '../utils/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/app_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde istatistik verilerini yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StatisticsProvider>(context, listen: false).loadStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // İstatistik provider'ını dinle
    final statisticsProvider = Provider.of<StatisticsProvider>(context);
    final statistics = statisticsProvider.statistics;
    final isLoading = statisticsProvider.isLoading;

    return AppScaffold(
      title: 'Ana Sayfa',
      currentIndex: 0, // Ana sayfa sekmesi seçili
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                                // Route kullanarak kategoriler sayfasına git
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.wordCategories,
                                );
                              },
                            ),
                            const Divider(height: 1),
                            _buildMenuItem(
                              'Yeni Kelime Öğren',
                              Icons.add_circle_outline,
                              onTap: () async {
                                final selectedLevel = await SelectedLevelService.getSelectedLevel();

                                if (selectedLevel == null) {
                                  // Seviye seçilmemiş, önce seviye seçimi ekranına git
                                  final newSelectedLevel = await Navigator.pushNamed(
                                    context,
                                    AppRoutes.wordCategories,
                                  );

                                  if (newSelectedLevel != null && newSelectedLevel is String) {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.wordLearn,
                                      arguments: newSelectedLevel,
                                    );
                                  }
                                } else {
                                  // Seviye zaten seçili, doğrudan öğrenmeye geç
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.wordLearn,
                                    arguments: selectedLevel,
                                  );
                                }
                              },
                            ),
                            const Divider(height: 1),
                            _buildMenuItem(
                              'Kelimeleri Tekrarla',
                              Icons.refresh,
                              onTap: () {
                                // Route kullanarak kelime tekrarlama sayfasına git
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.wordRepeat,
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
                      SizedBox(
                        height: 200,
                        child: _buildWeeklyChart(
                          isDark,
                          statistics.weeklyProgress,
                        ),
                      ),

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatCard(
                                    'Bugün Öğrenilen',
                                    '${statistics.learnedToday}/${statistics.dailyGoal}',
                                  ),
                                  const VerticalDivider(width: 1),
                                  _buildStatCard(
                                    'Toplam Seri 🔥',
                                    '${statistics.streakDays} gün',
                                  ),
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
                                    '${statistics.totalLearnedWords} kelime',
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

  Widget _buildWeeklyChart(bool isDark, Map<String, double> weeklyProgress) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children:
          weeklyProgress.entries.map((entry) {
            // Grafikte görselleştirme için değeri ölçekle
            double scaledValue =
                entry.value > 0 ? (entry.value * 30).clamp(10, 150) : 0;

            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: scaledValue, // Yüksekliği değere göre ayarla
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
                  if (entry.value > 0)
                    Text(
                      '${entry.value.toInt()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
