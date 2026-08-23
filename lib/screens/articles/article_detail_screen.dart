import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../utils/constants.dart';
import '../reports/report_form_screen.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.ghanaGold
        : AppColors.navy;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awareness Hub'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                ScamTypes.labelFor(article.category),
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.ghanaGold
                      : accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              article.body,
              style: const TextStyle(fontSize: 15, height: 1.7),
            ),
            const SizedBox(height: 28),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportFormScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: accentColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: accentColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Seen this scam? Report it',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}