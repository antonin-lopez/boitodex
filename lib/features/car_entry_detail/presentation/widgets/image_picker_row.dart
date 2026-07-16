import 'dart:io';

import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/theme/app_radius.dart';
import 'package:boitodex/core/theme/app_sizes.dart';

class ImagePickerRow extends StatelessWidget {
  const ImagePickerRow({
    required this.images,
    required this.onAddPressed,
    this.onRemove,
    super.key,
  });

  final List<File> images;
  final VoidCallback onAddPressed;
  final ValueChanged<int>? onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.thumbnail,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var i = 0; i < images.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: SizedBox(
                width: AppSizes.thumbnail,
                height: AppSizes.thumbnail,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Image.file(images[i], fit: BoxFit.cover),
                    ),
                    if (onRemove != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => onRemove!(i),
                          child: const CircleAvatar(
                            radius: 11,
                            backgroundColor: Colors.black54,
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          SizedBox(
            width: AppSizes.thumbnail,
            height: AppSizes.thumbnail,
            child: IconButton.filledTonal(
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              onPressed: onAddPressed,
              icon: const Icon(Icons.add_a_photo),
            ),
          ),
        ],
      ),
    );
  }
}
