import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';
import '../settings/settings_screen.dart';

class WhereToReportScreen extends StatelessWidget {
  const WhereToReportScreen({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Where to Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Official channels',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _ResourceCard(
              title: 'Cyber Security Authority (CSA) Ghana',
              subtitle: '24-hour national cybercrime hotline',
              icon: Icons.shield_outlined,
              accentColor: AppColors.success,
              rows: [
                _ContactRow(
                  icon: Icons.call,
                  label: 'Call or text',
                  value: '292',
                  onTap: () => _launch('tel:292'),
                ),
                _ContactRow(
                  icon: Icons.chat_bubble_outline,
                  label: 'WhatsApp',
                  value: '0501603111',
                  onTap: () => _launch('https://wa.me/233501603111'),
                ),
                _ContactRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: 'report@csa.gov.gh',
                  onTap: () => _launch('mailto:report@csa.gov.gh'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ResourceCard(
              title: 'Ghana Police Service',
              subtitle:
                  'Cyber Crime Unit (CID) — also available at regional commands',
              icon: Icons.local_police_outlined,
              accentColor: AppColors.navy,
              rows: [
                _ContactRow(
                  icon: Icons.call,
                  label: 'General police line',
                  value: '18555',
                  onTap: () => _launch('tel:18555'),
                ),
                _ContactRow(
                  icon: Icons.directions,
                  label: 'Get directions',
                  value: 'CID Headquarters, Accra',
                  onTap: () => _launch(
                    'https://www.google.com/maps/search/?api=1&query=CID+Headquarters+Ghana+Police+Service+Accra',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.charcoal,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'CyberSafe Ghana is an awareness and reporting tool, not a law enforcement agency. For urgent cases, contact these official channels directly.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<_ContactRow> rows;

  const _ResourceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 13)),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: onTap != null
                    ? (Theme.of(context).brightness == Brightness.dark
                          ? AppColors.ghanaGold
                          : AppColors.navy)
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
