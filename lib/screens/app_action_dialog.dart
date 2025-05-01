import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RateAppDialog extends StatelessWidget {
  const RateAppDialog({super.key});

  static const String _appUrl = 'https://play.google.com/store/apps/details?id=com.ingilizceogrenme.app'; // kendi app ID

  Future<void> _rateApp(BuildContext context) async {
    final uri = Uri.parse(_appUrl);
    Navigator.of(context).pop(); // Önce dialogu kapat
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Play açılmadı.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Uygulamayı Oyla'),
      content: const Text('Uygulamamızı beğendiysen, Google Play üzerinden oy verebilirsin!'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () => _rateApp(context),
          child: const Text('Oyla'),
        ),
      ],
    );
  }
}

class Scoring extends StatelessWidget {
  const Scoring({super.key});

  void _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.example.yourapp'; // Buraya kendi uygulama ID'ni yaz!
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Link açılamadı: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double _rating = 3.0;

    return AlertDialog(
      title: const Text('Uygulamayı Değerlendir'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Lütfen uygulamamızı puanlayın. Görüşleriniz bizim için önemli!'),
          const SizedBox(height: 16.0),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _rating = rating;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('İptal'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _launchURL();
          },
          child: const Text('Gönder'),
        ),
      ],
    );
  }
}