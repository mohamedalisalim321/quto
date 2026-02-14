import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../databases/quotes_database.dart';
import '../themes/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final themeProvider = context.watch<ThemeProvider>();
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _pageTitle(textTheme),
        _sectionTitle('Appearance'),
        _settingTile(
          title: 'Dark Mode',
          subtitle: 'Switch between light and dark theme',
          trailing: CupertinoSwitch(
            value: themeProvider.isDarkMode,
            onChanged: (_) {
              HapticFeedback.selectionClick();
              themeProvider.toggleTheme();
            },
          ),
        ),
        SizedBox(height: 24.h),
        _sectionTitle('Data'),
        _settingTile(
          title: 'Clear Favorites',
          subtitle: 'Remove all saved quotes',
          trailing: Icon(
            Icons.delete_outline,
            color: colors.error.withOpacity(0.8),
          ),
          onTap: () => _confirmClearFavorites(context),
        ),
        SizedBox(height: 24.h),
        _sectionTitle('Developer'),
        _settingTile(
          title: 'About Developer',
          subtitle: 'See The Developer',
          onTap: () => _showDeveloperDialog(),
        ),
      ],
    );
  }

  void _showDeveloperDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Mohamed Ali Salim",
            style: TextStyle(fontFamily: "Play"),
          ),
          content: Column(
            children: [
              // my image
              Image.asset(
                "assets/images/mohamed_ali_salim.jpg",
                fit: BoxFit.scaleDown,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.facebook_rounded,
                      color: Colors.blue,
                      size: 32.w,
                    ),
                    onPressed: () async {
                      final uri = Uri.parse(
                          'https://www.facebook.com/profile.php?id=61561233540084');

                      if (!await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw 'Could not launch $uri';
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.code_rounded,
                      color: Colors.grey,
                      size: 32.w,
                    ),
                    onPressed: () async {
                      final uri = Uri.parse(
                          'https://www.facebook.com/profile.php?id=61561233540084');

                      if (!await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw 'Could not launch $uri';
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _pageTitle(TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        'Settings',
        textAlign: TextAlign.center,
        style: textTheme.headlineSmall?.copyWith(
          fontFamily: "Inter",
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[400]
              : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Inter",
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _settingTile({
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontFamily: "Inter"),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: Colors.grey[400], fontFamily: "Inter"),
              )
            : null,
        trailing: trailing,
        enabled: onTap != null || trailing != null,
        onTap: onTap,
      ),
    );
  }

  Future<void> _confirmClearFavorites(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Clear favorites?',
          style: TextStyle(fontFamily: "Inter"),
        ),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(fontFamily: "Inter"),
        ),
        actions: [
          FilledButton(
            child: const Text('Cancel', style: TextStyle(fontFamily: "Inter")),
            onPressed: () => Navigator.pop(context, false),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear', style: TextStyle(fontFamily: "Inter")),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await QuotesDatabase.clearFavorites();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Favorites cleared'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
