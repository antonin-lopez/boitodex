import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_radius.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/features/item/domain/models/item.dart';
import 'package:boitodex/features/item/domain/models/item_image.dart';
import 'package:boitodex/features/item_entry_detail/presentation/screens/item_detail_screen.dart';

class ItemGridTile extends StatelessWidget {
  const ItemGridTile({required this.item, this.score, super.key});

  final Item item;
  final double? score;

  ItemImage? get _primaryImage {
    if (item.images.isEmpty) return null;
    return item.images.firstWhere(
      (image) => image.isPrimary,
      orElse: () => item.images.first,
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ItemDetailScreen(item: item, collectionId: item.collectionId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildImage(context)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                item.keywords.isEmpty
                    ? 'Sans mot-clé'
                    : item.keywords.map((k) => k.label).join(', '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final localPath = _primaryImage?.localPath;
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'item-image-${item.id}',
          child: localPath == null
              ? _ImagePlaceholder(colorScheme: colorScheme)
              : Image.file(
                  File(localPath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      _ImagePlaceholder(colorScheme: colorScheme),
                ),
        ),
        if (kDebugMode && score != null) _DebugScoreBadge(score: score!),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.colorScheme});

  static const double _iconSize = 32;

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.inventory_2_outlined,
        color: colorScheme.onSurfaceVariant,
        size: _iconSize,
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
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Text(
          score.toStringAsFixed(2),
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
