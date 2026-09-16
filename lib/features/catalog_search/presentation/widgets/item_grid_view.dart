import 'package:flutter/material.dart';

import 'package:boitodex/core/extensions/build_context_extensions.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/widgets/empty_state.dart';
import 'package:boitodex/features/item/domain/models/item.dart';
import 'package:boitodex/features/catalog_search/presentation/widgets/item_grid_tile.dart';

/// Grid displaying items with optional search similarity scores.
class ItemGridView extends StatelessWidget {
  const ItemGridView({required this.items, this.scores, super.key});

  // --- Colocated UI Constants ---
  static const int _crossAxisCount = 2;
  static const double _gridAspectRatio = 0.75;

  final List<Item> items;
  final Map<String, double>? scores;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.inventory_2_outlined,
        message:
            'Aucune voiture pour l’instant.\nAppuie sur + pour ajouter la première.',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ).copyWith(bottom: AppSpacing.sm + context.bottomSystemPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: _gridAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ItemGridTile(item: item, score: scores?[item.id]);
      },
    );
  }
}
