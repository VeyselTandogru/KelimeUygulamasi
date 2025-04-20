import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/accordion_item.dart';
import '../models/theme_model.dart';
import '../utils/app_constants.dart';
import '../routes/app_routes.dart';
import '../widgets/app_scaffold.dart';
// NavigationUtil'i içe aktaralım
import '../providers/statistics_provider.dart'; // StatisticsProvider eklendi

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Örnek kullanıcı bilgileri
  String username = 'Ikren';
  String email = 'hamza@example.com';
  int dailyGoal = 5;
  String levelCode = 'A2';

  @override
  void initState() {
    super.initState();
    // StatisticsProvider'dan günlük hedefi yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final statisticsProvider = Provider.of<StatisticsProvider>(
        context,
        listen: false,
      );
      setState(() {
        dailyGoal = statisticsProvider.statistics.dailyGoal;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'Hesabım',
      currentIndex: 3, // Hesap sekmesi seçili
      body: SingleChildScrollView(
        child: Padding(
          padding: AppConstants.paddingAllMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kullanıcı bilgileri bölümü
              _buildSection(
                children: [
                  AccordionItem(
                    title: 'Kullanıcı Adı',
                    iconData: Icons.person,
                    expandedContent: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: TextEditingController(text: username),
                          decoration: const InputDecoration(
                            hintText: 'örn: hamza',
                          ),
                          onChanged: (value) {
                            setState(() {
                              username = value;
                            });
                          },
                        ),
                        SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          'Kullanıcı adı size hitap edebilmemiz için kullanılacaktır. Bu yüzden eşsiz, anonim, kurala bağlı olması gerekmez, cihaz dışına çıkmaz.',
                          style: AppConstants.labelSmall,
                        ),
                        SizedBox(height: AppConstants.paddingMedium),
                        ElevatedButton(
                          onPressed: () {
                            // Kullanıcı adını kaydet
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Kullanıcı adı kaydedildi'),
                                backgroundColor: AppConstants.successColor,
                              ),
                            );
                          },
                          child: const Text('Kaydet'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  AccordionItem(
                    title: 'E-posta Adresi',
                    iconData: Icons.email,
                    expandedContent: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: TextEditingController(text: email),
                          decoration: const InputDecoration(
                            hintText: 'E-posta adresiniz',
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        SizedBox(height: AppConstants.paddingMedium),
                        ElevatedButton(
                          onPressed: () {
                            // E-posta adresini kaydet
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'E-posta adresi kaydedildi',
                                ),
                                backgroundColor: AppConstants.successColor,
                              ),
                            );
                          },
                          child: const Text('Kaydet'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.paddingMedium),

              // Uygulama ayarları bölümü
              _buildSection(
                children: [
                  AccordionItem(
                    title: 'Günlük Hedef',
                    iconData: Icons.calendar_today,
                    expandedContent: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Günlük kaç kelime öğrenmek istiyorsunuz?',
                          style: textTheme.bodyLarge,
                        ),
                        SizedBox(height: AppConstants.paddingSmall),
                        Slider(
                          value: dailyGoal.toDouble(),
                          min: 1,
                          max: 20,
                          divisions: 19,
                          label: dailyGoal.toString(),
                          onChanged: (value) {
                            setState(() {
                              dailyGoal = value.toInt();
                            });
                          },
                        ),
                        Text(
                          'Günlük hedef: $dailyGoal kelime',
                          style: textTheme.bodyMedium,
                        ),
                        SizedBox(height: AppConstants.paddingMedium),
                        ElevatedButton(
                          onPressed: () {
                            // StatisticsProvider'ı kullanarak günlük hedefi güncelle
                            final statisticsProvider =
                                Provider.of<StatisticsProvider>(
                                  context,
                                  listen: false,
                                );

                            // Günlük hedefi güncelle
                            statisticsProvider.updateDailyGoal(dailyGoal);

                            // Kullanıcıya bilgi mesajı göster
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Günlük hedef kaydedildi'),
                                backgroundColor: AppConstants.successColor,
                              ),
                            );
                          },
                          child: const Text('Kaydet'),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  _buildMenuItemWithIcon(
                    'Kelime Grupları',
                    Icons.layers,
                    onTap: () {
                      // Kelime grupları sayfasına git
                      Navigator.pushNamed(context, AppRoutes.wordCategories);
                    },
                  ),
                ],
              ),

              SizedBox(height: AppConstants.paddingMedium),

              // Tema ayarları bölümü
              _buildSection(
                children: [
                  SwitchListTile(
                    title: Text('Koyu Tema', style: textTheme.titleLarge),
                    secondary: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color:
                          themeProvider.isDarkMode
                              ? Colors.amber
                              : AppConstants.primaryColor,
                      size: AppConstants.iconSize,
                    ),
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                  ),
                ],
              ),

              SizedBox(height: AppConstants.paddingMedium),

              // Geri bildirim bölümü
              _buildSection(
                children: [
                  _buildMenuItemWithIcon(
                    'Uygulamaya Oy Ver',
                    Icons.star,
                    color: Colors.amber,
                    onTap: () {
                      // Uygulama mağazasına yönlendir
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItemWithIcon(
                    'Uygulamayı Paylaş',
                    Icons.share,
                    onTap: () {
                      // Paylaşım sayfasını aç
                    },
                  ),
                ],
              ),

              SizedBox(height: AppConstants.paddingMedium),

              // Hakkında bölümü
              _buildSection(
                children: [
                  _buildMenuItemWithIcon(
                    'Uygulamamız Hakkında',
                    Icons.info,
                    onTap: () {
                      // Route kullanarak Hakkında sayfasına git
                      Navigator.pushNamed(context, AppRoutes.about);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required List<Widget> children}) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(borderRadius: AppConstants.roundedLarge),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItemWithIcon(
    String title,
    IconData iconData, {
    Color color = AppConstants.primaryColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(iconData, color: color, size: AppConstants.iconSize),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
