import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'What does "Verified" mean on a report?',
      'answer':
          'A verified report means an admin reviewed it and confirmed it looks '
          'legitimate — not a hoax or duplicate. It does not mean police have '
          'investigated the case. For formal investigation, contact the CSA or '
          'Ghana Police directly via the Resources tab.',
    },
    {
      'question': 'Why can\'t I delete a verified report?',
      'answer':
          'Once a report is verified, it becomes part of the public record used '
          'for awareness statistics. Deletion is only allowed while a report is '
          'still pending, to protect the integrity of that public data.',
    },
    {
      'question': 'Is my identity shown when I submit a report?',
      'answer':
          'Your identity is never shown publicly. If you enable "Submit '
          'anonymously" when reporting, your report is also excluded entirely '
          'from the public verified-scams feed.',
    },
    {
      'question': 'Why is the suspect\'s contact info shown publicly?',
      'answer':
          'On verified reports, the suspect\'s phone number or account is shown '
          'so others can recognize a repeat scammer. This does not apply to '
          'your own identity as the reporter, which stays private.',
    },
    {
      'question': 'How do I reset my password if I forgot it?',
      'answer':
          'On the login screen, tap "Forgot password?" and enter your email. '
          'You\'ll receive a 6-digit code by email to reset your password.',
    },
    {
      'question': 'Can I use my email to log in instead of my username?',
      'answer':
          'Yes — the login screen accepts either your email or your username.',
    },
    {
      'question': 'How do I report a scam?',
      'answer':
          'Go to the Reports tab and tap the "+ Report" button. Fill in the '
          'scam type, description, and region, then submit.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help / FAQ')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _faqs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          return Card(
            child: ExpansionTile(
              title: Text(
                faq['question']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq['answer']!,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
