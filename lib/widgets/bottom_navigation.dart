import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor:
          Theme.of(context).brightness == Brightness.dark
              ? AppColors.textDarkSubtitle
              : AppColors.textLightSubtitle,
      iconSize: 24.0,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'An Sayfa'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Öğrenme'),
        BottomNavigationBarItem(icon: Icon(Icons.refresh), label: 'Tekrar'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hesabım'),
      ],
    );
  }
}
