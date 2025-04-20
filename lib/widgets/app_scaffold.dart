import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../routes/app_routes.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final bool showBackButton;
  final List<Widget>? actions;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.currentIndex,
    this.showBackButton = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton,
      ),
      body: body,
      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          // Alt navigasyon çubuğundaki sekmelerin yönlendirme işlemleri
          if (index == currentIndex) return; // Zaten seçili sekmedeyiz

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.wordLearn);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.wordRepeat);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.account);
              break;
          }
        },
      ),
    );
  }
}
