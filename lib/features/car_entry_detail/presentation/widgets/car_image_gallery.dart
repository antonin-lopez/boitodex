import 'dart:io';

import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_radius.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/theme/app_sizes.dart';
import 'package:boitodex/features/car/domain/models/car_image.dart';
import 'package:boitodex/features/car_entry_detail/presentation/screens/car_image_viewer_screen.dart';

class CarImageGallery extends StatefulWidget {
  const CarImageGallery({required this.images, super.key});

  final List<CarImage> images;

  @override
  State<CarImageGallery> createState() => _CarImageGalleryState();
}

class _CarImageGalleryState extends State<CarImageGallery> {
  final _pageController = PageController();
  var _currentPage = 0;

  List<String> get _localPaths => widget.images
      .map((image) => image.localPath)
      .whereType<String>()
      .toList();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openViewer(BuildContext context, List<String> paths, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            CarImageViewerScreen(imagePaths: paths, initialIndex: initialIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paths = _localPaths;
    if (paths.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AspectRatio(
        aspectRatio: AppSizes.galleryAspectRatio,
        child: Stack(
          children: [
            ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: PageView.builder(
                controller: _pageController,
                itemCount: paths.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => _openViewer(context, paths, index),
                  child: Image.file(File(paths[index]), fit: BoxFit.contain),
                ),
              ),
            ),
            if (paths.length > 1)
              Positioned(
                bottom: AppSpacing.sm,
                left: 0,
                right: 0,
                child: _PageIndicator(
                  count: paths.length,
                  currentIndex: _currentPage,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Container(
            width: AppSizes.galleryIndicatorDotSize,
            height: AppSizes.galleryIndicatorDotSize,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == currentIndex
                  ? colorScheme.primary
                  : colorScheme.surface,
            ),
          ),
      ],
    );
  }
}
