import 'dart:io';

import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_radius.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/features/car/domain/models/car_image.dart';
import 'package:boitodex/features/car_entry_detail/presentation/screens/car_image_viewer_screen.dart';

class CarImageGallery extends StatelessWidget {
  const CarImageGallery({
    required this.images,
    this.excludePrimary = false,
    super.key,
  });

  final List<CarImage> images;
  final bool excludePrimary;

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
    final allPaths = images
        .map((image) => image.localPath)
        .whereType<String>()
        .toList();
    if (allPaths.isEmpty) return const SizedBox.shrink();

    final primaryPath = images
        .firstWhere((img) => img.isPrimary, orElse: () => images.first)
        .localPath;

    final displayPaths = excludePrimary
        ? allPaths.where((path) => path != primaryPath).toList()
        : allPaths;
    if (displayPaths.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: displayPaths.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.xs,
        crossAxisSpacing: AppSpacing.xs,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final path = displayPaths[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: GestureDetector(
            onTap: () => _openViewer(context, allPaths, allPaths.indexOf(path)),
            child: Image.file(File(path), fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
