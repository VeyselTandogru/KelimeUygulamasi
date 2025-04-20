import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/word_learn_screen.dart';
import 'screens/word_repeat_screen.dart';
import 'screens/account_screen.dart';
import 'widgets/bottom_navigation.dart';
import 'models/theme_model.dart';
import 'providers/statistics_provider.dart';

void main() {
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
      home: MainScreen(key: MainScreenState._stateKey),
    );
  }
}

class MainScreen extends StatefulWidget {
  static void navigateToHome(BuildContext context) {
    final MainScreenState? state = MainScreenState.of(context);
    if (state != null) {
      state.setTab(0);
    }
  }

  static void navigateToLearning(BuildContext context) {
    final MainScreenState? state = MainScreenState.of(context);
    if (state != null) {
      state.setTab(1);
    }
  }

  static void navigateToRepeat(BuildContext context) {
    final MainScreenState? state = MainScreenState.of(context);
    if (state != null) {
      state.setTab(2);
    }
  }

  static void navigateToAccount(BuildContext context) {
    final MainScreenState? state = MainScreenState.of(context);
    if (state != null) {
      state.setTab(3);
    }
  }

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  static final GlobalKey<MainScreenState> _stateKey =
      GlobalKey<MainScreenState>();

  static MainScreenState? of(BuildContext context) {
    final MainScreenState? state = _stateKey.currentState;
    return state;
  }

  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WordLearnScreen(),
    const WordRepeatScreen(),
    const AccountScreen(),
  ];

  void setTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class NavigationUtil {
  static void navigateWithBottomBar(
    BuildContext context,
    Widget screen, {
    int selectedTab = 0,
  }) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              body: screen,
              bottomNavigationBar: BottomNavigation(
                currentIndex: selectedTab,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      MainScreen.navigateToHome(context);
                      break;
                    case 1:
                      MainScreen.navigateToLearning(context);
                      break;
                    case 2:
                      MainScreen.navigateToRepeat(context);
                      break;
                    case 3:
                      MainScreen.navigateToAccount(context);
                      break;
                  }
                },
              ),
            ),
      ),
    );
  }
}
