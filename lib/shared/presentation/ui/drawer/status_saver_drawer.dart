import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_status/application/common/app_images.dart';
import 'package:whatsapp_status/application/extensions/context_extensions.dart';
import 'package:whatsapp_status/application/theme/app_colors.dart';
import 'package:whatsapp_status/shared/presentation/ui/drawer/widgets/how_to_use.dart';
import 'package:whatsapp_status/src/settings/providers/settings_provider.dart';
import 'package:whatsapp_status/src/settings/select_whatsapp.dart';
import 'package:whatsapp_status/src/settings/language_settings.dart';
import 'package:whatsapp_status/src/settings/toggle_theme_switch.dart';

class StatusSaverDrawer extends ConsumerWidget {
  const StatusSaverDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
              const Color(0xFF1E1E1E),
              const Color(0xFF2D2D2D),
            ]
                : [
              Colors.white,
              const Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: Column(
          children: [
            // Enhanced Header
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF075E54),
                    Color(0xFF128C7E),
                    Color(0xFF25D366),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha:0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with animation container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha:0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha:0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          AppImages.logo3,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // App title
                    const Text(
                      'Status Box',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Text(
                      'Save & Share WhatsApp Status',
                      style: TextStyle(
                        color: AppColors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildSectionHeader(context, 'Select WhatsApp Version'),
                  const SelectWhatsapp(),

                  const SizedBox(height: 8),

                  _buildSectionHeader(context, 'Settings'),
                  // Theme Toggle
                  _buildMenuTile(
                    context: context,
                    icon: Icons.dark_mode_rounded,
                    title: context.l10n.darkTheme,
                    iconColor: AppColors.indigo,
                    trailing: const ToggleThemeSwitch(),
                    onTap: () {
                      final isDark = ref.read(settingsProvider).isDarkMode;
                      ref.read(settingsProvider.notifier).toggleTheme(!isDark);
                    },
                  ),

                  // Language
                  _buildMenuTile(
                    context: context,
                    icon: Icons.language_rounded,
                    title: context.l10n.language,
                    iconColor: AppColors.blue,
                    onTap: () => switchLanguage(context, ref),
                  ),

                  const SizedBox(height: 16),
                  _buildSectionHeader(context, 'Support'),

                  // How to Use
                  _buildMenuTile(
                    context: context,
                    icon: Icons.help_outline_rounded,
                    title: context.l10n.howToUse,
                    iconColor: AppColors.amber,
                    onTap: () => howToUse(context),
                  ),

                  // Share
                  _buildMenuTile(
                    context: context,
                    icon: Icons.share_rounded,
                    title: context.l10n.share,
                    iconColor: AppColors.green,
                    onTap: () {
                      Share.share(
                        'You can download all Whatsapp status for free and fast. Download it here: https://play.google.com/store/apps/details?id=com.devzeal.status_saver',
                        subject: 'Status Saver',
                      );
                    },
                  ),

                  // Rate Us
                  _buildMenuTile(
                    context: context,
                    icon: Icons.star_rounded,
                    title: context.l10n.rateUs,
                    iconColor: AppColors.orange,
                    onTap: () {
                      // Add rate us functionality
                    },
                  ),

                  // Privacy Policy
                  _buildMenuTile(
                    context: context,
                    icon: Icons.privacy_tip_rounded,
                    title: context.l10n.privacyPolicy,
                    iconColor: AppColors.red,
                    onTap: () {
                      // Add privacy policy functionality
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Divider(
                    color: AppColors.grey.withValues(alpha:0.3),
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© 2025 Harshit Ramani',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10,
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[400]
              : Colors.grey[700],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark
            ? Colors.grey[850]?.withValues(alpha:0.5)
            : AppColors.white.withValues(alpha:0.7),
        border: Border.all(
          color: isDark
              ? Colors.grey[700]!.withValues(alpha:0.3)
              : Colors.grey[300]!.withValues(alpha:0.5),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.white : AppColors.black87,
          ),
        ),
        trailing: trailing ?? (onTap != null
            ? Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey[400],
        )
            : null),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
      ),
    );
  }

  void howToUse(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return const HowToUseDialog();
      },
    );
  }
}