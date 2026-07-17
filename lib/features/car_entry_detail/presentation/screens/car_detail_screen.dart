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

    // La fiche a pu être modifiée pendant l'écran d'édition : on rafraîchit.
    final refreshed = await ref.read(carRepositoryProvider).getCarById(_car.id);
    if (refreshed != null && mounted) {
      setState(() => _car = refreshed);
    }
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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(carEntryDetailControllerProvider).isLoading;
    final hasKeywords = _car.keywords.isNotEmpty;
    final hasNotes = _car.notes != null && _car.notes!.isNotEmpty;

    final sections = <Widget>[
      CarImageGallery(images: _car.images),
      if (hasKeywords)
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            for (final keyword in _car.keywords)
              Chip(label: Text(keyword.label)),
          ],
        ),
      if (hasNotes)
        Text(_car.notes!, style: Theme.of(context).textTheme.bodyLarge),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la voiture'),
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
                  ),
                ),
              ),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _edit(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + context.bottomSystemInset,
        ),
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            sections[i],
          ],
        ],
      ),
    );
  }
}
