import 'dart:io';

import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_radius.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/features/car/domain/models/car_image.dart';
import 'package:boitodex/features/car_entry_detail/presentation/screens/car_image_viewer_screen.dart';

class CarImageGallery extends StatelessWidget {
  const CarImageGallery({required this.images, super.key});

  final List<CarImage> images;

  List<String> get _localPaths =>
      images.map((image) => image.localPath).whereType<String>().toList();

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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding:
          EdgeInsets.zero, // <- empêche l'injection auto du MediaQuery.padding
      itemCount: paths.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.xs,
        crossAxisSpacing: AppSpacing.xs,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: GestureDetector(
          onTap: () => _openViewer(context, paths, index),
          child: Image.file(File(paths[index]), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
