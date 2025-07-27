import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_status/application/common/app_images.dart';
import 'package:whatsapp_status/application/extensions/context_extensions.dart';
import 'package:whatsapp_status/application/theme/app_colors.dart';
import 'package:whatsapp_status/router/app_routes.dart';
import 'package:whatsapp_status/src/onboarding/presentation/providers/onboarding_provider.dart';

class OnBoardingScreen extends ConsumerWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(),
              Image.asset(AppImages.logo3, height: 150, width: 150),

              // Title
              Text(
                "Status Box",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "- ",
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "Status Saver",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  Text(
                    " -",
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.primary,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18.0),
              Text(context.l10n.statusSaverDescription),
              const Spacer(),
              Text(
                context.l10n.permissionPrompt,
                style: const TextStyle(fontSize: 8.0),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width),
                ),
                onPressed: () async {
                  await ref
                      .read(onBoardingProvider.notifier)
                      .requestPermission();

                  context.go(AppRoutes.homeScreen);
                },
                child: Text(context.l10n.grantPermission),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
