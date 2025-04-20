import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../routes/app_routes.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uygulamamız Hakkında'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.account);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Hoş geldiniz! Uygulamamız, İngilizce öğrenmek isteyen öğrenciler için özel olarak tasarlanmıştır. Öğrenme sürecinizi daha etkili ve keyifli hale getirmek için Ebbinghaus Öğrenme Eğrisi yöntemini kullanıyoruz. Bu yöntem, bilgilerinizi uzun süreli hafızanıza yerleştirmek için tekrar aralıklarını optimize eder.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Özelliklerimiz'),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    'Otomatik Çeviri:',
                    'Kelime ve cümle çevirilerimiz, güvenilir Oxford Sözlüğü altyapısı ile sağlanmaktadır.',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    'Kişiselleştirilmiş öğrenme deneyimi:',
                    'Kelime grupları, günlük hedefler ve seviyenizi seçerek öğrenme sürecinizi özelleştirebilirsiniz.',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    'İlerleme takibi:',
                    'Haftalık istatistikler ve grafikler ile gelişiminizi kolayca takip edebilirsiniz',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Bize Ulaşın'),
                  const SizedBox(height: 8),
                  const Text(
                    'Sorularınız, önerileriniz veya teklifleriniz için bize abc@gmail.com adresinden ulaşabilirsiniz.',
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Uygulama Versiyonu'),
                  const SizedBox(height: 8),
                  const Text(
                    'Versiyon 1.0.0',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '© 2023 İngilizce Öğrenme Uygulaması\nTüm hakları saklıdır.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(description, style: const TextStyle(fontSize: 15, height: 1.4)),
      ],
    );
  }
}
