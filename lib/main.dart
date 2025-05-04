import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/theme_model.dart';
import 'providers/statistics_provider.dart';
import 'routes/app_routes.dart';
import 'services/repeat_words_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RepeatWordsService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => StatisticsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'İngilizce Öğrenme Uygulaması',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.getRoutes(),
    );
  }
}

class NavigationUtil {
  static void navigateWithBottomBar(
    BuildContext context,
    String routeName, {
    int selectedTab = 0,
  }) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
