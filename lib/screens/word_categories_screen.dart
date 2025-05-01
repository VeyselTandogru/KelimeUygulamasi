import 'package:flutter/material.dart';
import '../services/selected_evel_services.dart';
import '../utils/app_colors.dart';
import '../services/categories_service.dart';
import '../widgets/app_scaffold.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class WordCategoriesScreen extends StatefulWidget {
  const WordCategoriesScreen({super.key});

  @override
  State<WordCategoriesScreen> createState() => _WordCategoriesScreenState();
}

class _WordCategoriesScreenState extends State<WordCategoriesScreen> {
  // Kategori servisi
  final CategoriesService _categoriesService = CategoriesService();

  // Kategori listesi
  // Şimdilik mevsim gün ay zaman kaldırdım
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Oxford - A1',
      'level': 'A1',
      'color': Colors.green.shade200,
      'isSelected': false,
    },
    {
      'name': 'Oxford - A2',
      'level': 'A2',
      'color': Colors.red.shade200,
      'isSelected': false,
    },
    {
      'name': 'Oxford - B1',
      'level': 'B1',
      'color': Colors.cyan.shade200,
      'isSelected': false,
    },
    {
      'name': 'Oxford - B2',
      'level': 'B2',
      'color': Colors.blue.shade200,
      'isSelected': false,
    },
    {
      'name': 'Oxford - C1',
      'level': 'C1',
      'color': Colors.purple.shade200,
      'isSelected': false,
    },
    {
      'name': 'Oxford - C2',
      'level': 'C2',
      'color': Colors.deepPurple.shade200,
      'isSelected': false,
    },
    {
      'name': 'Günler',
      'level': 'Gün',
      'color': Colors.orange.shade200,
      'isSelected': false,
    },
    {
      'name': 'Aylar',
      'level': 'Ay',
      'color': Colors.amber.shade200,
      'isSelected': false,
    },
    {
      'name': 'Yıllar',
      'level': 'Yıl',
      'color': Colors.teal.shade200,
      'isSelected': false,
    },
    {
      'name': 'Zaman Kavramları',
      'level': 'Zaman',
      'color': Colors.pink.shade200,
      'isSelected': false,
    },
    {
      'name': 'Mevsimler',
      'level': 'Mevsim',
      'color': Colors.lightGreen.shade200,
      'isSelected': false,
    },
  ];
  @override
  void initState() {
    super.initState();
    _loadSavedCategories();
    _loadWordCountsFromJson(); // <<< YENİ FONKSİYON
  }

  // Kaydedilmiş kategori seçimlerini yükle
  Future<void> _loadSavedCategories() async {
    final selectedNames = await _categoriesService.getSelectedCategories();

    // Mevcut listedeki kategorileri kayıtlı seçimlere göre güncelle
    if (selectedNames.isNotEmpty) {
      setState(() {
        for (var i = 0; i < categories.length; i++) {
          final categoryName = categories[i]['name'] as String;
          if (selectedNames.contains(categoryName)) {
            categories[i]['isSelected'] = true;
          }
        }
      });
    }
  }

  Future<void> _loadWordCountsFromJson() async {
    final String jsonString = await rootBundle.loadString('assets/merged.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    // Her level için kaç kelime var onu hesapla
    Map<String, int> levelCounts = {};

    for (var item in jsonData) {
      final level = item['turkceKategori'] as String?;
      if (level != null) {
        levelCounts[level] = (levelCounts[level] ?? 0) + 1;
      }
    }

    // Şimdi categories listesindeki count'ları güncelle
    setState(() {
      for (var category in categories) {
        final level = category['level'] as String;
        category['count'] = levelCounts[level] ?? 0;
      }
    });
  }

  // Kategori seçimlerini kaydet
  void _saveSelectedCategories() {
    _categoriesService.saveSelectedCategories(categories);
  }

  int get selectedCount => categories.where((cat) => cat['isSelected']).length;
  int get totalWordCount => categories.fold(0, (total, category) {
  if (category['isSelected'] == true) {
    return total + (category['count'] ?? 0) as int;
  }
  return total;
}); /*
  void toggleCategory(int index) {
    setState(() {
      categories[index]['isSelected'] = !(categories[index]['isSelected'] as bool);
      _saveSelectedCategories();
    });
  }*/

  void toggleCategory(int index) {
    setState(() {
      // Önce tüm seçimleri temizle
      for (var i = 0; i < categories.length; i++) {
        categories[i]['isSelected'] = false;
      }
      // Sadece tıklananı seç
      categories[index]['isSelected'] = true;

      // Seçimi kaydet
      _saveSelectedCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Kelime Grupları',
      currentIndex: 0, // Ana sayfa sekmesi seçili
      showBackButton: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Seçilen kategori bilgisi
          _buildSelectedInfo(),

          // Kategori listesi
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryItem(category, index);
                  },
                ),
              ),
            ),
          ),

          // Başlat butonu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedCount > 0
                  ? () async {
                      final selectedCategory =
                          categories.firstWhere((cat) => cat['isSelected']);
                      final selectedLevel = selectedCategory['level'];

                      await SelectedLevelService.setSelectedLevel(
                          selectedLevel); // Seçimi kaydet
                      Navigator.pop(
                          context, selectedLevel); // Seçimi geri döndür
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  selectedCount > 0
                      ? 'Seçilen Kelimeleri Öğren'
                      : 'Lütfen kategori seçin',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedInfo() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit, color: AppColors.primary, size: 24.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$selectedCount kategori seçildi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                Text(
                  'Toplam kelime sayısı: $totalWordCount',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLightSubtitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category, int index) {
    final Color categoryColor = category['color'];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 4.0,
      ),
      leading: Theme(
        data: Theme.of(context).copyWith(
          checkboxTheme: CheckboxThemeData(
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return categoryColor;
              }
              return null;
            }),
          ),
        ),
        child: Checkbox(
          value: category['isSelected'],
          onChanged: (value) => toggleCategory(index),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          side: BorderSide(color: categoryColor, width: 2.0),
        ),
      ),
      title: Text(
        category['name'],
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Text(
        category['count'].toString(),
        style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
      ),
      onTap: () => toggleCategory(index),
    );
  }
}
