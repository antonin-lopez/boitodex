import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/core/extensions/build_context_extensions.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/theme/app_sizes.dart';
import 'package:boitodex/core/widgets/async_result_handler.dart';
import 'package:boitodex/features/car/data/providers/car_providers.dart';
import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/car_entry_detail/presentation/controllers/car_entry_detail_controller.dart';
import 'package:boitodex/features/car_entry_detail/presentation/screens/car_entry_screen.dart';
import 'package:boitodex/features/car_entry_detail/presentation/screens/car_image_viewer_screen.dart';
import 'package:boitodex/features/car_entry_detail/presentation/widgets/car_image_gallery.dart';

class CarDetailScreen extends ConsumerStatefulWidget {
  const CarDetailScreen({
    required this.car,
    required this.collectionId,
    super.key,
  });

  final Car car;
  final String collectionId;

  @override
  ConsumerState<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends ConsumerState<CarDetailScreen> {
  late Car _car = widget.car;

  @override
  void didUpdateWidget(covariant CarDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.car.id != oldWidget.car.id) _car = widget.car;
  }

  Future<void> _edit(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CarEntryScreen(
          collectionId: widget.collectionId,
          existingCar: _car,
        ),
      ),
    );
    if (!mounted) return;

    final refreshed = await ref.read(carRepositoryProvider).getCarById(_car.id);
    if (refreshed != null && mounted) setState(() => _car = refreshed);
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
        .read(carEntryDetailControllerProvider.notifier)
        .deleteCar(_car.id);
    if (!context.mounted) return;

    handleAsyncActionResult(
      context,
      ref.read(carEntryDetailControllerProvider),
      onSuccess: (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Voiture supprimée')));
        Navigator.of(context).pop();
      },
    );
  }

  String? get _primaryImagePath {
    if (_car.images.isEmpty) return null;
    return _car.images
        .firstWhere((img) => img.isPrimary, orElse: () => _car.images.first)
        .localPath;
  }

  void _openHeroViewer(BuildContext context) {
    final paths = _car.images
        .map((img) => img.localPath)
        .whereType<String>()
        .toList();
    if (paths.isEmpty) return;

    final startIndex = paths.indexOf(_primaryImagePath ?? paths.first);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CarImageViewerScreen(
          imagePaths: paths,
          initialIndex: startIndex < 0 ? 0 : startIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(carEntryDetailControllerProvider).isLoading;
    final colorScheme = Theme.of(context).colorScheme;
    final hasKeywords = _car.keywords.isNotEmpty;
    final hasNotes = _car.notes != null && _car.notes!.isNotEmpty;
    final hasExtraPhotos = _car.images.length > 1;
    final imagePath = _primaryImagePath;

    // Ratio 4:3 plutôt qu'une hauteur fixe : évite un crop trop serré
    // quel que soit la largeur de l'écran.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final heroHeight = (screenWidth / AppSizes.heroImageAspectRatio).clamp(
      AppSizes.heroImageMinHeight,
      AppSizes.heroImageMaxHeight,
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
                      width: AppSizes.spinner,
                      height: AppSizes.spinner,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizes.spinnerStrokeWidth,
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
                  tag: 'car-image-${_car.id}',
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
                      // Léger scrim en haut pour renforcer le contraste
                      // des boutons, indépendamment de la photo.
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
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md + context.bottomSystemInset,
            ),
            sliver: SliverList.list(
              children: [
                if (hasExtraPhotos) ...[
                  _SectionCard(
                    title: 'Autres photos',
                    child: CarImageGallery(
                      images: _car.images,
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
                        for (final keyword in _car.keywords)
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
                      _car.notes!,
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

/// Bouton icône avec fond circulaire translucide, pour rester lisible
/// peu importe ce qui se trouve derrière (photo claire ou sombre).
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

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.directions_car,
        size: AppSizes.placeholderIcon * 2,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
