import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/core/extensions/build_context_extensions.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/widgets/async_result_handler.dart';
import 'package:boitodex/features/item/data/providers/item_providers.dart';
import 'package:boitodex/features/item/domain/models/item.dart';
import 'package:boitodex/features/item_entry_detail/presentation/controllers/item_entry_detail_controller.dart';
import 'package:boitodex/features/item_entry_detail/presentation/screens/item_entry_screen.dart';
import 'package:boitodex/features/item_entry_detail/presentation/screens/item_image_viewer_screen.dart';
import 'package:boitodex/features/item_entry_detail/presentation/widgets/item_image_gallery.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  const ItemDetailScreen({
    required this.item,
    required this.collectionId,
    super.key,
  });

  final Item item;
  final String collectionId;

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  // --- Colocated UI Constants ---
  static const double _heroAspectRatio = 4 / 3;
  static const double _heroMinHeight = 220;
  static const double _heroMaxHeight = 340;
  static const double _spinnerSize = 20;
  static const double _spinnerStrokeWidth = 2;

  late Item _item = widget.item;

  @override
  void didUpdateWidget(covariant ItemDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.id != oldWidget.item.id) _item = widget.item;
  }

  Future<void> _edit(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ItemEntryScreen(
          collectionId: widget.collectionId,
          existingItem: _item,
        ),
      ),
    );
    if (!mounted) return;

    final refreshed = await ref.read(itemRepositoryProvider).getItemById(_item.id);
    if (refreshed != null && mounted) setState(() => _item = refreshed);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer cette voiture ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await ref
        .read(itemEntryDetailControllerProvider.notifier)
        .deleteItem(_item.id);
    if (!context.mounted) return;

    ref
        .read(itemEntryDetailControllerProvider)
        .handleResult(
          context,
          onSuccess: (_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Voiture supprimée')));
            Navigator.of(context).pop();
          },
        );
  }

  String? get _primaryImagePath {
    if (_item.images.isEmpty) return null;
    return _item.images
        .firstWhere((img) => img.isPrimary, orElse: () => _item.images.first)
        .localPath;
  }

  void _openHeroViewer(BuildContext context) {
    final paths = _item.images
        .map((img) => img.localPath)
        .whereType<String>()
        .toList();
    if (paths.isEmpty) return;

    final startIndex = paths.indexOf(_primaryImagePath ?? paths.first);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ItemImageViewerScreen(
          imagePaths: paths,
          initialIndex: startIndex < 0 ? 0 : startIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(itemEntryDetailControllerProvider).isLoading;
    final colorScheme = Theme.of(context).colorScheme;
    final hasKeywords = _item.keywords.isNotEmpty;
    final hasNotes = _item.notes != null && _item.notes!.isNotEmpty;
    final hasExtraPhotos = _item.images.length > 1;
    final imagePath = _primaryImagePath;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final heroHeight = (screenWidth / _heroAspectRatio).clamp(
      _heroMinHeight,
      _heroMaxHeight,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: heroHeight,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            leading: _ScrimIconButton(
              icon: Icons.arrow_back,
              tooltip: 'Retour',
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Center(
                    child: SizedBox(
                      width: _spinnerSize,
                      height: _spinnerSize,
                      child: CircularProgressIndicator(
                        strokeWidth: _spinnerStrokeWidth,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else ...[
                _ScrimIconButton(
                  icon: Icons.edit,
                  tooltip: 'Modifier',
                  onPressed: () => _edit(context),
                ),
                _ScrimIconButton(
                  icon: Icons.delete_outline,
                  tooltip: 'Supprimer',
                  onPressed: () => _confirmDelete(context, ref),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () => _openHeroViewer(context),
                child: Hero(
                  tag: 'item-image-${_item.id}',
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      imagePath == null
                          ? _HeroPlaceholder(colorScheme: colorScheme)
                          : Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  _HeroPlaceholder(colorScheme: colorScheme),
                            ),
                      // Top gradient scrim ensuring control visibility regardless of photo contrast.
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black38, Colors.transparent],
                            stops: [0.0, 0.35],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(
              AppSpacing.md,
            ).copyWith(bottom: AppSpacing.md + context.bottomSystemPadding),
            sliver: SliverList.list(
              children: [
                if (hasExtraPhotos) ...[
                  _SectionCard(
                    title: 'Autres photos',
                    child: ItemImageGallery(
                      images: _item.images,
                      excludePrimary: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (hasKeywords) ...[
                  _SectionCard(
                    title: 'Mots-clés',
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final keyword in _item.keywords)
                          Chip(label: Text(keyword.label)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (hasNotes)
                  _SectionCard(
                    title: 'Notes',
                    child: Text(
                      _item.notes!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular semi-opaque icon button for guaranteed contrast over media backgrounds.
class _ScrimIconButton extends StatelessWidget {
  const _ScrimIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          tooltip: tooltip,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder({required this.colorScheme});

  static const double _iconSize = 64;

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.inventory_2_outlined,
        size: _iconSize,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
