import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/theme/app_sizes.dart';
import 'package:boitodex/core/widgets/async_result_handler.dart';
import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/car_entry_detail/presentation/controllers/car_entry_detail_controller.dart';
import 'package:boitodex/features/car_entry_detail/presentation/screens/car_entry_screen.dart';
import 'package:boitodex/features/car_entry_detail/presentation/widgets/car_image_gallery.dart';

class CarDetailScreen extends ConsumerWidget {
  const CarDetailScreen({
    required this.car,
    required this.collectionId,
    super.key,
  });

  final Car car;
  final String collectionId;

  Future<void> _edit(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            CarEntryScreen(collectionId: collectionId, existingCar: car),
      ),
    );
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

    await ref.read(carEntryDetailControllerProvider.notifier).deleteCar(car.id);
    if (!context.mounted) return;

    handleAsyncActionResult(
      context,
      ref.read(carEntryDetailControllerProvider),
      onSuccess: (_) => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(carEntryDetailControllerProvider).isLoading;
    final hasKeywords = car.keywords.isNotEmpty;
    final hasNotes = car.notes != null && car.notes!.isNotEmpty;

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
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          CarImageGallery(images: car.images),
          if (hasKeywords) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                for (final keyword in car.keywords)
                  Chip(label: Text(keyword.label)),
              ],
            ),
          ],
          if (hasNotes) ...[
            const SizedBox(height: AppSpacing.md),
            Text(car.notes!, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ],
      ),
    );
  }
}
