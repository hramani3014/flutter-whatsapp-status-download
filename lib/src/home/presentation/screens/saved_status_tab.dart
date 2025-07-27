import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_status/application/theme/app_colors.dart';
import 'package:whatsapp_status/shared/presentation/ui/drawer/widgets/how_to_use.dart';
import 'package:whatsapp_status/src/home/domain/entities/whatsapp_status.dart';
import 'package:whatsapp_status/src/status_preview/providers/full_screen_media_provider.dart';
import 'package:whatsapp_status/router/app_routes.dart';
import 'package:whatsapp_status/src/home/presentation/providers/whatsapp_status_providers.dart';
import 'package:whatsapp_status/shared/presentation/widgets/grid_child.dart';

class SavedStatusTab extends ConsumerWidget {
  const SavedStatusTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedStatusesState = ref.watch(savedStatusProvider);

    final List<WhatsappStatus> images = [];
    final List<WhatsappStatus> videos = [];

    return savedStatusesState.when(
      data: (data) {
        if (data.isNotEmpty) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                axisDirection: AxisDirection.down,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                children: data.map((status) {
                  final extension = status.file.path.split('.').last;
                  bool isVideo = false;

                  if (extension == 'jpg' || extension == 'png') {
                    images.add(status);
                  }
                  if (extension == 'mp4') {
                    videos.add(status);
                    isVideo = true;
                  }

                  return GridChild(
                    onTap: () {
                      final notifier = ref.read(fullScreenMediaProvider);
                      if (isVideo) {
                        notifier.setMedia(videos, videos.indexOf(status), true);
                        context.push(AppRoutes.fullScreenVideo);
                      } else {
                        notifier.setMedia(images, images.indexOf(status), true);
                        context.push(AppRoutes.fullScreenImage);
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        isVideo
                            ? Image.memory(status.thumbnail!)
                            : Image.file(status.file as File),
                        if (isVideo)
                          const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        } else {
          // No saved statuses available – show custom empty state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular icon container
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
                  child: const Center(
                    child: Icon(
                      Icons.save_alt_outlined,
                      size: 60,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Saved Status Available Now',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.primaryLight),
                ),
                const SizedBox(height: 16),

                // HOW TO USE button
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

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '* Open Saved Tab \n* Tap on any Image or Video \n* Use Save Button to Download',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

