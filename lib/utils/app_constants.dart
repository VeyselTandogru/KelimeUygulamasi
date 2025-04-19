import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Uygulamanın sabit değerlerini tutan sınıf
class AppConstants {
  // Renkleri AppColors sınıfından alıyoruz
  static const Color primaryColor = AppColors.primary;
  static const Color accentColor = AppColors.accent;
  static const Color lightBackground = AppColors.lightBackground;
  static const Color darkBackground = AppColors.darkBackground;
  static const Color darkCardColor = AppColors.cardDarkBackground;
  static const Color darkSurfaceColor = AppColors.surfaceDark;
  static const Color successColor = AppColors.success;
  static const Color errorColor = AppColors.error;
  static const Color warningColor = AppColors.warning;
  static const Color infoColor = AppColors.info;
  static const Color textDarkColor = AppColors.textDark;
  static const Color textLightColor = AppColors.textLight;
  static const Color subtitleLightColor = AppColors.textLightSubtitle;
  static const Color subtitleDarkColor = AppColors.textDarkSubtitle;

  // Metin stilleri
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyLarge = TextStyle(fontSize: 16);

  static const TextStyle bodyMedium = TextStyle(fontSize: 14);

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  // Boşluklar ve padding değerleri
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const EdgeInsets paddingAllSmall = EdgeInsets.all(paddingSmall);
  static const EdgeInsets paddingAllMedium = EdgeInsets.all(paddingMedium);
  static const EdgeInsets paddingAllLarge = EdgeInsets.all(paddingLarge);

  // Radiusler
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 24.0;

  static BorderRadius roundedSmall = BorderRadius.circular(borderRadiusSmall);
  static BorderRadius roundedMedium = BorderRadius.circular(borderRadiusMedium);
  static BorderRadius roundedLarge = BorderRadius.circular(borderRadiusLarge);
  static BorderRadius roundedXLarge = BorderRadius.circular(borderRadiusXLarge);

  // Gölge değerleri
  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: AppColors.shadowDark,
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];

  // Animasyon süreleri
  static const Duration animationDurationShort = Duration(milliseconds: 150);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // Özel boyutlar
  static const double buttonHeight = 48.0;
  static const double appBarHeight = 56.0;
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeLarge = 32.0;
  static const double cardElevation = 2.0;

  // İnputlar için
  static const InputDecoration defaultInputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    filled: true,
  );

  // Button stilleri
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: primaryColor,
    minimumSize: const Size(double.infinity, buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
  );

  static final ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: BorderSide(color: primaryColor),
    minimumSize: const Size(double.infinity, buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
  );
}
