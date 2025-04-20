import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesService {
  static const String _categoriesKey = 'selected_categories';

  // Singleton yapısı
  static final CategoriesService _instance = CategoriesService._internal();
  factory CategoriesService() => _instance;
  CategoriesService._internal();

  // Seçili kategorileri kaydet
  Future<bool> saveSelectedCategories(
    List<Map<String, dynamic>> categories,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Sadece seçili kategorilerin isimlerini kaydet
    final selectedCategoryNames =
        categories
            .where((category) => category['isSelected'] == true)
            .map((category) => category['name'] as String)
            .toList();

    return await prefs.setStringList(_categoriesKey, selectedCategoryNames);
  }

  // Kaydedilmiş kategorileri yükle
  Future<List<String>> getSelectedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_categoriesKey) ?? [];
  }

  // Verilen kategoriler listesini saklanan seçimlerle güncelle
  Future<List<Map<String, dynamic>>> updateCategoriesWithSavedSelections(
    List<Map<String, dynamic>> categories,
  ) async {
    final selectedCategoryNames = await getSelectedCategories();

    return categories.map((category) {
      final name = category['name'] as String;
      bool isSelected = selectedCategoryNames.contains(name);

      // Kategori bilgilerini kopyala ve isSelected'ı güncelle
      return {...category, 'isSelected': isSelected};
    }).toList();
  }
}
