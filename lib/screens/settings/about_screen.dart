import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.ghanaGold
        : AppColors.navy;

    return Scaffold(
      appBar: AppBar(title: const Text('About CyberSafe Ghana')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/icon/app_icon_final.png',
                height: 90,
                width: 90,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'CyberSafe Ghana',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 28),
            _SectionTitle('Our Mission'),
            const SizedBox(height: 8),
            const Text(
              'CyberSafe Ghana is a cybercrime awareness and reporting app built to help '
              'Ghanaians recognize, avoid, and report common scams — including mobile money '
              'fraud, phishing, SIM swap fraud, romance scams, and job scams.',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 20),
            _SectionTitle('What We Do'),
            const SizedBox(height: 8),
            const Text(
              '• Let users report scams they\'ve experienced or witnessed\n'
              '• Show verified, real scam reports to help others stay alert\n'
              '• Provide educational articles on common Ghana-specific scams\n'
              '• Connect users to official channels like the Cyber Security '
              'Authority (CSA) and Ghana Police Service',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 20),
            _SectionTitle('Important Note'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'CyberSafe Ghana is an awareness and reporting tool, not a law '
                'enforcement agency. Verified reports have been reviewed for '
                'legitimacy, not investigated by police. For urgent cases, contact '
                'official authorities directly via the Resources tab.',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.charcoal,
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
