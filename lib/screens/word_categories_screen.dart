import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../main.dart';

class WordCategoriesScreen extends StatefulWidget {
  const WordCategoriesScreen({super.key});

  @override
  State<WordCategoriesScreen> createState() => _WordCategoriesScreenState();
}

class _WordCategoriesScreenState extends State<WordCategoriesScreen> {
  // Kategori listesi
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Oxford - A1',
      'count': 340,
      'color': Colors.green.shade200,
      'isSelected': false,
    },
    {
      'name': 'Oxford - A2',
      'count': 280,
      'color': Colors.red.shade200,
      'isSelected': false,
    },
    {
      'name': 'Oxford - B1',
      'count': 120,
      'color': Colors.cyan.shade200,
      'isSelected': false,
    },
    {
      'name': 'Oxford - B2',
      'count': 130,
      'color': Colors.blue.shade200,
      'isSelected': false,
    },
    {
      'name': 'Günler ve Aylar',
      'count': 19,
      'color': Colors.amber.shade200,
      'isSelected': false,
    },
    {
      'name': 'Mevsimler',
      'count': 4,
      'color': Colors.lightGreen.shade200,
      'isSelected': false,
    },
    {
      'name': 'Zaman',
      'count': 34,
      'color': Colors.pink.shade200,
      'isSelected': false,
    },
  ];

  int get selectedCount => categories.where((cat) => cat['isSelected']).length;
  int get totalWordCount {
    int total = 0;
    for (var category in categories) {
      if (category['isSelected']) {
        total += category['count'] as int;
      }
    }
    return total;
  }

  void toggleCategory(int index) {
    setState(() {
      categories[index]['isSelected'] = !categories[index]['isSelected'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelime Grupları'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Ana sayfaya dön
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false, // Tüm önceki sayfaları kaldır
            );
          },
        ),
      ),
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
                  separatorBuilder:
                      (context, index) => const Divider(height: 1),
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
              onPressed:
                  selectedCount > 0
                      ? () {
                        // Seçilen kategorilerle öğrenmeyi başlat
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$selectedCount kategori ile başlatılıyor',
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
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
