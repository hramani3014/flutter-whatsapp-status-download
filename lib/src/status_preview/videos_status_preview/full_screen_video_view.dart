import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_status/application/extensions/context_extensions.dart';
import 'package:whatsapp_status/application/theme/app_colors.dart';
import 'package:whatsapp_status/core/enums/status_directory.dart';
import 'package:whatsapp_status/src/home/domain/entities/whatsapp_status.dart';
import 'package:whatsapp_status/src/home/presentation/providers/use_case_providers.dart';
import 'package:whatsapp_status/src/status_preview/providers/full_screen_media_provider.dart';
import 'package:whatsapp_status/src/status_preview/videos_status_preview/full_screen_video.dart';

class FullscreenVideoViewer extends ConsumerStatefulWidget {
  const FullscreenVideoViewer({super.key});

  @override
  ConsumerState<FullscreenVideoViewer> createState() =>
      _FullscreenVideoViewerState();
}

class _FullscreenVideoViewerState extends ConsumerState<FullscreenVideoViewer> {
  late final PageController _pageController;
  late final List<WhatsappStatus> videos;
  late final int initialIndex;
  late final FullScreenMediaProvider notifier;
  bool _showUI = true;
  int _currentIndex = 0;
  Set<int> _savedIndices = {}; // Track which videos are saved

  @override
  void initState() {
    notifier = ref.read(fullScreenMediaProvider);
    videos = notifier.media;
    initialIndex = notifier.index;
    _currentIndex = initialIndex;
    _pageController = PageController(initialPage: initialIndex);
    super.initState();
  }

  void _toggleUI() {
    setState(() {
      _showUI = !_showUI;
    });
  }

  Future<void> _saveCurrentVideo() async {
    try {
      final currentFile = videos[_currentIndex].file as File;
      await ref
          .read(saveSavedStatusUseCaseProvider)
          .execute(StatusDirectory.savedStatus.directory, currentFile);

      setState(() {
        _savedIndices.add(_currentIndex);
      });

      if (context.mounted) {
        context.showSnackBarMessage('Status saved successfully');
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBarMessage('Error: $e');
      }
    }
  }

  void _shareCurrentVideo() {
    final currentFile = videos[_currentIndex].file as File;
    Share.shareXFiles(
      [XFile(currentFile.path)],
      text: 'Shared from WhatsApp Status Saver',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main PageView
          GestureDetector(
            onTap: _toggleUI,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal, // Keep vertical scroll for videos
              itemCount: videos.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (final _, final index) {
                final video = videos[index].file as File;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    FullScreenVideo(video: video),
                  ],
                );
              },
            ),
          ),

          // Top Overlay with Back Button and Counter
          AnimatedOpacity(
            opacity: _showUI ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha:0.7),
                    Colors.black.withValues(alpha:0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Back Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha:0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.of(context).pop(),
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Video Counter
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF075E54).withValues(alpha:0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha:0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${_currentIndex + 1} / ${videos.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Side Navigation Dots - Fixed on right side for vertical scroll
          // if (videos.length > 1)
          //   Positioned(
          //     bottom: 100, // Position above the action buttons
          //     left: 0,
          //     right: 0, // Position above the action buttons
          //     child: AnimatedOpacity(
          //       opacity: _showUI ? 1.0 : 0.0,
          //       duration: const Duration(milliseconds: 300),
          //       child: Container(
          //         alignment: Alignment.center,
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //           decoration: BoxDecoration(
          //             color: Colors.black.withValues(alpha:0.6),
          //             borderRadius: BorderRadius.circular(20),
          //             border: Border.all(
          //               color: Colors.white.withValues(alpha:0.1),
          //               width: 1,
          //             ),
          //           ),
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: List.generate(
          //               videos.length > 5 ? 5 : videos.length,
          //                   (index) {
          //                 int actualIndex = index;
          //                 if (videos.length > 5) {
          //                   if (_currentIndex < 2) {
          //                     actualIndex = index;
          //                   } else if (_currentIndex > videos.length - 3) {
          //                     actualIndex = videos.length - 5 + index;
          //                   } else {
          //                     actualIndex = _currentIndex - 2 + index;
          //                   }
          //                 }
          //
          //                 bool isActive = actualIndex == _currentIndex;
          //                 return AnimatedContainer(
          //                   duration: const Duration(milliseconds: 300),
          //                   margin: const EdgeInsets.symmetric(vertical: 3),
          //                   width: 8,
          //                   height: isActive ? 28 : 8,
          //                   decoration: BoxDecoration(
          //                     color: isActive
          //                         ? const Color(0xFF075E54)
          //                         : Colors.white.withValues(alpha:0.4),
          //                     borderRadius: BorderRadius.circular(4),
          //                   ),
          //                 );
          //               },
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),


          if (videos.length > 1)
            Positioned(
              bottom: 100, // Position above the action buttons
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _showUI ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha:0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha:0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        videos.length > 5 ? 5 : videos.length,
                            (index) {
                          int actualIndex = index;
                          if (videos.length > 5) {
                            if (_currentIndex < 2) {
                              actualIndex = index;
                            } else if (_currentIndex > videos.length - 3) {
                              actualIndex = videos.length - 5 + index;
                            } else {
                              actualIndex = _currentIndex - 2 + index;
                            }
                          }

                          bool isActive = actualIndex == _currentIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: isActive ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF075E54)
                                  : Colors.white.withValues(alpha:0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Bottom Action Bar - Fixed at very bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showUI ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha:0.8),
                      Colors.black.withValues(alpha:0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Share Button
                        _buildActionButton(
                          icon: Icons.share_rounded,
                          label: 'Share',
                          onTap: _shareCurrentVideo,
                        ),

                        // Download Button
                        _buildActionButton(
                          icon: _savedIndices.contains(_currentIndex)
                              ? Icons.check_circle
                              : Icons.download,
                          label: _savedIndices.contains(_currentIndex)
                              ? 'Saved'
                              : 'Download',
                          onTap: _savedIndices.contains(_currentIndex)
                              ? null
                              : _saveCurrentVideo,
                        ),

                        // Details Button
                        _buildActionButton(
                          icon: Icons.info_outline_rounded,
                          label: 'Details',
                          onTap: () {
                            _showVideoInfo(context, videos[_currentIndex].file as File);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final bool isDisabled = onTap == null;

    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: isDisabled
                        ? Colors.white.withValues(alpha:0.6)
                        : Colors.white,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isDisabled
                          ? Colors.white.withValues(alpha:0.6)
                          : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showVideoInfo(BuildContext context, File videoFile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Video Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              _buildInfoRow('File Name', videoFile.path.split('/').last),
              _buildInfoRow('File Size', _getFileSize(videoFile)),
              _buildInfoRow('File Path', videoFile.path),
              _buildInfoRow('Status', _savedIndices.contains(_currentIndex) ? 'Saved' : 'Not Saved'),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withValues(alpha:0.1),
                width: 1,
              ),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}