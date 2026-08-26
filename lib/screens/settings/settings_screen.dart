import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme_controller.dart';
import '../auth/login_screen.dart';
import '../../models/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppUser? _user;
  bool _isLoadingUser = true;

    @override
    void initState() {
      super.initState();
      _loadUser();
    }

    Future<void> _loadUser() async {
      final user = await AuthService.getCurrentUser();
      setState(() {
        _user = user;
        _isLoadingUser = false;
      });
    }

    Future<void> _handleLogout() async {
      final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to log in again to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Log out', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings')
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Display',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeController.themeMode,
              builder: (context, mode, _) {
                return SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark mode'),
                  value: mode == ThemeMode.dark,
                  activeThumbColor: AppColors.navy,
                  onChanged: (value) {
                    ThemeController.toggle(value);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Account',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: _isLoadingUser
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _user == null
                    ? const ListTile(title: Text('Could not load account info'))
                    : Column(
                        children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(_user!.username),
                          subtitle: Text(_user!.email.isNotEmpty ? _user!.email : 'No email set'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          title: Text(_user!.region.isNotEmpty ? _user!.region : 'No region set'),
                          subtitle: const Text('Region'),
                        ),
                      ],
                    ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: AppColors.danger),
              title: Text('Log out', style: TextStyle(color: AppColors.danger)),
              onTap: _handleLogout,
            ),
          ),
        ],
      ),
    );
  }
}
