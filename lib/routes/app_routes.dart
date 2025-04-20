import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/word_categories_screen.dart';
import '../screens/word_learn_screen.dart';
import '../screens/word_repeat_screen.dart';
import '../screens/account_screen.dart';
import '../screens/about_screen.dart';

// Route adlarını sabit olarak tanımlama
class AppRoutes {
  static const String home = '/';
  static const String wordCategories = '/word-categories';
  static const String wordLearn = '/word-learn';
  static const String wordRepeat = '/word-repeat';
  static const String account = '/account';
  static const String about = '/about';

  // Route tanımlamaları
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      wordCategories: (context) => const WordCategoriesScreen(),
      wordLearn: (context) => const WordLearnScreen(),
      wordRepeat: (context) => const WordRepeatScreen(),
      account: (context) => const AccountScreen(),
      about: (context) => const AboutScreen(),
    };
  }
}
