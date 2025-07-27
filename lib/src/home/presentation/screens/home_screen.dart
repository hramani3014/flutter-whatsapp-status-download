import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_status/application/common/app_images.dart';
import 'package:whatsapp_status/application/extensions/context_extensions.dart';
import 'package:whatsapp_status/application/theme/app_colors.dart';
import 'package:whatsapp_status/shared/presentation/ui/drawer/status_saver_drawer.dart';
import 'package:whatsapp_status/src/home/presentation/screens/images_tab.dart';
import 'package:whatsapp_status/src/home/presentation/screens/saved_status_tab.dart';
import 'package:whatsapp_status/src/home/presentation/screens/videos_tab.dart';
import 'package:whatsapp_status/src/settings/providers/settings_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        // WhatsApp green
        foregroundColor: AppColors.white,
        title:
        // Row(
        //   children: [
        // Container(
        //   padding: const EdgeInsets.all(8),
        //   decoration: BoxDecoration(
        //     color: AppColors.white.withValues(alpha:0.2),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: const Icon(
        //     Icons.save_alt_rounded,
        //     size: 20,
        //     color: AppColors.white,
        //   ),
        // ),
        // const SizedBox(width: 12),
        Text(
          'Status Box',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        //   ],
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child:
                settings.isWhatsapp
                    ? Image.asset(
                      AppImages
                          .whatsappA,
                      width: 28,
                      height: 28,
                    )
                    : Image.asset(
                      AppImages.whatsappB,
                      width: 28,
                      height: 28,
                    ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            color: AppColors.primary,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.white,
              indicatorWeight: 3,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.white70,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image_rounded, size: 18),
                      const SizedBox(width: 6),
                      Text(context.l10n.images),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_rounded, size: 18),
                      const SizedBox(width: 6),
                      Text(context.l10n.videos),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bookmark_rounded, size: 18),
                      const SizedBox(width: 6),
                      Text(context.l10n.saved),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: colorScheme.surface,
        child: const StatusSaverDrawer(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withValues(alpha: 0.4),
              colorScheme.surface,
            ],
            stops: const [0.0, 0.6],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [ImageStatus(), VideosStatus(), SavedStatusTab()],
        ),
      ),
    );
  }
}
