import 'package:flutter/material.dart';

/// Uygulamada kullanılan tüm renkleri tanımlayan sınıf
class AppColors {
  // Ana renkler
  static const Color primary = Colors.purple;
  static const Color accent = Color(0xFF3F51B5);
  static const Color secondary = Color(0xFF673AB7);

  // Arka plan renkleri
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardDarkBackground = Color(0xFF252525);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Metin renkleri
  static const Color textLight = Colors.black87;
  static const Color textDark = Colors.white;
  static const Color textLightSubtitle = Colors.black54;
  static const Color textDarkSubtitle = Colors.white70;

  // Bildirim renkleri
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Gölge renkleri
  static Color shadowLight = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.2);
}
