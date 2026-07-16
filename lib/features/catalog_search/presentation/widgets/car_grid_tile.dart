import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/theme/app_colors.dart';
import 'package:boitodex/core/theme/app_radius.dart';
import 'package:boitodex/core/theme/app_sizes.dart';
import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/car/domain/models/car_image.dart';

class CarGridTile extends StatelessWidget {
  const CarGridTile({required this.car, this.score, super.key});

  final Car car;
  final double? score;

  CarImage? get _primaryImage {
    if (car.images.isEmpty) return null;
    return car.images.firstWhere(
      (image) => image.isPrimary,
      orElse: () => car.images.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildImage(context)),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Text(
              car.keywords.isEmpty
                  ? 'Sans mot-clé'
                  : car.keywords.map((k) => k.label).join(', '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final localPath = _primaryImage?.localPath;

    return Stack(
      fit: StackFit.expand,
      children: [
        localPath == null
            ? _ImagePlaceholder(colorScheme: Theme.of(context).colorScheme)
            : Image.file(
                File(localPath),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _ImagePlaceholder(
                  colorScheme: Theme.of(context).colorScheme,
                ),
              ),
        if (kDebugMode && score != null) _DebugScoreBadge(score: score!),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.directions_car,
        color: colorScheme.onSurfaceVariant,
        size: AppSizes.placeholderIcon,
      ),
    );
  }
}

class _DebugScoreBadge extends StatelessWidget {
  const _DebugScoreBadge({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.xs,
      right: AppSpacing.xs,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.debugBadgeHorizontalPadding,
          vertical: AppSizes.debugBadgeVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.imageOverlayScrim,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          score.toStringAsFixed(2),
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.onImageOverlay),
        ),
      ),
    );
  }
}
