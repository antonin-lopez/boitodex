import 'dart:io';

import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/theme/app_radius.dart';
import 'package:boitodex/core/theme/app_sizes.dart';

class ImagePickerRow extends StatelessWidget {
  const ImagePickerRow({
    required this.images,
    required this.onAddPressed,
    super.key,
  });

  final List<File> images;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.thumbnail,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final image in images)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.file(
                  image,
                  width: AppSizes.thumbnail,
                  height: AppSizes.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          IconButton.filledTonal(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add_a_photo),
          ),
        ],
      ),
    );
  }
}
