import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../databases/quotes_database.dart';
import '../themes/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _clearing = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _pageTitle(textTheme),

        /// ========= APPEARANCE =========
        _group(
          title: "Appearance",
          children: [
            _tile(
              icon: Icons.dark_mode_rounded,
              title: "Dark Mode",
              subtitle: "Change Between Light Mode and Dark Mode",
              trailing: CupertinoSwitch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  themeProvider.toggleTheme();
                },
              ),
              onTap: () {
                HapticFeedback.selectionClick();
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),

        /// ========= DATA =========
        _group(
          title: "Data",
          children: [
            _tile(
              icon: Icons.favorite_outline,
              title: "Clear Favorites",
              subtitle: "Remove all saved quotes",
              trailing: _clearing
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      Icons.delete_outline,
                      color: colors.error.withOpacity(.9),
                    ),
              onTap: _clearing ? null : _confirmClearFavorites,
            ),
          ],
        ),

        /// ========= DEVELOPER =========
        _group(
          title: "Developer",
          children: [
            _tile(
              icon: Icons.person_rounded,
              title: "About Developer",
              onTap: _showDeveloperDialog,
            ),
          ],
        ),
      ],
    );
  }

  // ================= GROUP =================

  Widget _group({required String title, required List<Widget> children}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          Column(children: children)
        ],
      ),
    );
  }

  // ================= TILE =================

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: Colors.grey))
          : null,
      trailing: trailing,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      onTap: onTap,
    );
  }

  // ================= TITLE =================

  Widget _pageTitle(TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Center(
        child: Text(
          "Settings",
          style: textTheme.headlineSmall?.copyWith(
            fontFamily: "Inter",
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // ================= CLEAR FAVORITES =================

  Future<void> _confirmClearFavorites() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear favorites?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Clear"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _clearing = true);
    await QuotesDatabase.clearFavorites();
    setState(() => _clearing = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Favorites cleared")),
    );
  }

  // ================= DEVELOPER =================

  void _showDeveloperDialog() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 96.r,
              backgroundImage:
                  const AssetImage("assets/images/mohamed_ali_salim.jpg"),
            ),
            SizedBox(height: 12.h),
            Text(
              "Mohamed Ali Salim",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialButton(
                  icon: Icons.facebook_rounded,
                  color: Colors.blue,
                  url: "https://www.facebook.com/profile.php?id=61561233540084",
                ),
                SizedBox(width: 22.w),
                _socialButton(
                  icon: Icons.code_rounded,
                  color: Colors.black,
                  url: "https://github.com/mohamedalisalim321/quto",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required Color color,
    required String url,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50.r),
      onTap: () async {
        final uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: CircleAvatar(
        radius: 22.r,
        backgroundColor: color.withOpacity(.15),
        child: Icon(icon, color: color),
      ),
    );
  }
}
