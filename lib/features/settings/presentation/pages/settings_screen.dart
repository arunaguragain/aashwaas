import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/app/theme/theme_mode_provider.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/features/auth/presentation/pages/donor_login_page.dart';
import 'package:aashwaas/features/auth/presentation/pages/volunteer_login_page.dart';
import 'package:aashwaas/features/auth/presentation/view_model/donor_auth_viewmodel.dart';
import 'package:aashwaas/features/auth/presentation/view_model/volunteer_auth_viewmodel.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/edit_profile_screen.dart';
import 'package:aashwaas/features/settings/presentation/pages/settings_info_page.dart';
import 'package:aashwaas/features/settings/presentation/widgets/settings_group.dart';
import 'package:aashwaas/features/settings/presentation/widgets/settings_switch_tile.dart';
import 'package:aashwaas/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const String _notificationsKey = 'settings_notifications_enabled';
  static const String _darkModeKey = 'settings_dark_mode_enabled';

  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final storedNotifications = prefs.getBool(_notificationsKey);
    final storedDarkMode = prefs.getBool(_darkModeKey);

    if (!mounted) {
      return;
    }

    setState(() {
      _notificationsEnabled = storedNotifications ?? true;
      _darkModeEnabled = storedDarkMode ?? false;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_notificationsKey, value);
    if (!mounted) {
      return;
    }
    setState(() => _notificationsEnabled = value);
    MySnackbar.showInfo(
      context,
      value ? 'Notifications enabled' : 'Notifications disabled',
    );
  }

  Future<void> _toggleDarkMode(bool value) async {
    await ref.read(themeModeProvider.notifier).setDarkMode(value);
    if (!mounted) {
      return;
    }
    setState(() => _darkModeEnabled = value);
  }

  Future<void> _handleLogout() async {
    final userSessionService = ref.read(userSessionServiceProvider);
    final role = userSessionService.getUserRoleSync() ?? 'donor';

    if (role == 'volunteer') {
      await ref.read(authVolunteerViewmodelProvider.notifier).logout();
      if (!mounted) {
        return;
      }
      AppRoutes.pushAndRemoveUntil(context, const VolunteerLoginScreen());
      return;
    }

    await ref.read(authDonorViewmodelProvider.notifier).logout();
    if (!mounted) {
      return;
    }
    AppRoutes.pushAndRemoveUntil(context, const DonorLoginScreen());
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _handleLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 10),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 13,
                color: _darkModeEnabled
                    ? Colors.black87
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              SettingsSwitchTile(
                icon: Icons.notifications_none,
                title: 'Notifications',
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
              ),
              SettingsSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                value: _darkModeEnabled,
                onChanged: _toggleDarkMode,
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 10),
            child: Text(
              'Support',
              style: TextStyle(
                fontSize: 13,
                color: _darkModeEnabled
                    ? Colors.black87
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () {
                  AppRoutes.push(
                    context,
                    const SettingsInfoPage.terms(),
                  );
                },
              ),
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {
                  AppRoutes.push(
                    context,
                    const SettingsInfoPage.privacy(),
                  );
                },
              ),
              SettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  AppRoutes.push(
                    context,
                    const SettingsInfoPage.about(),
                  );
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 18),
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: _confirmLogout,
                titleColor: const Color(0xFFE53935),
                iconColor: const Color(0xFFE53935),
                showChevron: false,
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
