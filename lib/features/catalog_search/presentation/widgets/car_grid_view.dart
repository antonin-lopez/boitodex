import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/extensions/build_context_extensions.dart';
import 'package:boitodex/core/theme/app_sizes.dart';
import 'package:boitodex/core/widgets/empty_state.dart';
import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/catalog_search/presentation/widgets/car_grid_tile.dart';

class CarGridView extends StatelessWidget {
  const CarGridView({required this.cars, this.scores, super.key});

  final List<Car> cars;
  final Map<String, double>? scores;

  @override
  Widget build(BuildContext context) {
    if (cars.isEmpty) {
      return const EmptyState(
        icon: Icons.directions_car_outlined,
        message:
            'Aucune voiture pour l’instant.\nAppuie sur + pour ajouter la première.',
      );
    }
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm + context.bottomSystemInset,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppSizes.catalogGridCrossAxisCount,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: AppSizes.catalogGridAspectRatio,
      ),
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return CarGridTile(car: car, score: scores?[car.id]);
      },
    );
  }
}
