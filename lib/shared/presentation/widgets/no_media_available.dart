import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_status/application/theme/app_colors.dart';
import 'package:whatsapp_status/shared/presentation/ui/drawer/widgets/how_to_use.dart';
import 'package:whatsapp_status/src/settings/providers/settings_provider.dart';

class NoMediaAvailable extends ConsumerWidget {
  const NoMediaAvailable({
    super.key,
    required this.type,
    required this.icon,
  });

  final String type;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final String platformName =
    settings.isWhatsappBusiness ? 'WhatsApp Business' : 'WhatsApp';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFE0F2F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 60,
              color: AppColors.primaryLight,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          'No $type Available Now',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.primaryLight),
        ),
        const SizedBox(height: 16.0),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const HowToUseDialog(),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'HOW TO USE?',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '* Open $platformName \n* View Statuses \n* Open this App to Download',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
