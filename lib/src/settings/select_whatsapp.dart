import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_status/application/common/app_images.dart';
import 'package:whatsapp_status/application/theme/app_colors.dart';
import 'package:whatsapp_status/core/enums/status_directory.dart';
import 'package:whatsapp_status/src/settings/providers/settings_provider.dart';

class SelectWhatsapp extends ConsumerWidget {
  const SelectWhatsapp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(builder: (context) {
      final state = ref.watch(settingsProvider);
      final provider = ref.read(settingsProvider.notifier);
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  _buildWhatsAppOption(
                    context: context,
                    image: AppImages.whatsapp,
                    title: 'WhatsApp',
                    subtitle: 'Personal messaging',
                    isSelected: state.isWhatsapp,
                    onTap: () => provider.setStatusDir(StatusDirectory.whatsapp),
                    gradientColors: [
                      // const Color(0xFF25D366),
                      // const Color(0xFF128C7E),
                      const Color(0xFF00A884),
                      const Color(0xFF075E54),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildWhatsAppOption(
                    context: context,
                    image: AppImages.whatsappBusiness,
                    title: 'WhatsApp Business',
                    subtitle: 'Business communication',
                    isSelected: state.isWhatsappBusiness,
                    onTap: () => provider.setStatusDir(StatusDirectory.whatsappBusiness),
                    gradientColors: [
                      const Color(0xFF00A884),
                      const Color(0xFF075E54),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildWhatsAppOption({
    required BuildContext context,
    required String image,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required List<Color> gradientColors,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
          colors: [
            gradientColors[0].withValues(alpha:0.15),
            gradientColors[1].withValues(alpha:0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )
            : null,
        color: isSelected
            ? null
            : (isDark
            ? Colors.grey[800]?.withValues(alpha:0.3)
            : Colors.grey[50]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? gradientColors[0].withValues(alpha:0.4)
              : (isDark
              ? Colors.grey[700]!.withValues(alpha:0.3)
              : Colors.grey[300]!.withValues(alpha:0.4)),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: gradientColors[0].withValues(alpha:0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // App Icon Container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha:0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    image,
                    height: 32,
                    width: 32,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(width: 16),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.white : AppColors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? gradientColors[0]
                        : AppColors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? gradientColors[0]
                          : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}