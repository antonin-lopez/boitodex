import 'dart:io';

import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_radius.dart';
import 'package:boitodex/core/theme/app_spacing.dart';

/// Horizontal reorderable row for selecting, previewing, and sorting item photos.
class ImagePickerRow extends StatelessWidget {
  const ImagePickerRow({
    required this.images,
    required this.onAddPressed,
    required this.onReorder,
    this.onRemove,
    super.key,
  });

  // --- Colocated UI Constants ---
  static const int maxItemImages = 10;
  static const double _thumbnailSize = 72;

  final List<File> images;
  final VoidCallback onAddPressed;
  final void Function(int oldIndex, int newIndex) onReorder;
  final ValueChanged<int>? onRemove;

  bool get _isAtLimit => images.length >= maxItemImages;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _thumbnailSize,
          child: ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            buildDefaultDragHandles: false,
            itemCount: images.length + (_isAtLimit ? 0 : 1),
            onReorderItem: (oldIndex, newIndex) {
              // The add button is fixed at the end and cannot be reordered.
              if (oldIndex >= images.length) return;
              final target = newIndex.clamp(0, images.length - 1);
              onReorder(oldIndex, target);
            },
            itemBuilder: (context, index) {
              if (index >= images.length) {
                return _AddTile(
                  key: const ValueKey('add-photo-tile'),
                  size: _thumbnailSize,
                  onPressed: onAddPressed,
                );
              }

              final file = images[index];
              return Padding(
                key: ValueKey(file.path),
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: SizedBox(
                  width: _thumbnailSize,
                  height: _thumbnailSize,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Image.file(file, fit: BoxFit.cover),
                      ),
                      if (index == 0)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: colorScheme.primary,
                            shadows: const [
                              Shadow(color: Colors.black54, blurRadius: 3),
                            ],
                          ),
                        ),
                      if (onRemove != null)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => onRemove!(index),
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
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: ReorderableDragStartListener(
                          index: index,
                          child: const CircleAvatar(
                            radius: 11,
                            backgroundColor: Colors.black54,
                            child: Icon(
                              Icons.drag_handle,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Limite de photos : ${images.length}/$maxItemImages',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.onPressed, required this.size, super.key});

  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton.filledTonal(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
