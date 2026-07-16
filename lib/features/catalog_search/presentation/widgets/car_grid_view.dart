import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/extensions/build_context_extensions.dart';
import 'package:boitodex/core/theme/app_sizes.dart';
import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/catalog_search/presentation/widgets/car_grid_tile.dart';

class CarGridView extends StatelessWidget {
  const CarGridView({required this.cars, this.scores, super.key});

  final List<Car> cars;
  final Map<String, double>? scores;

  @override
  Widget build(BuildContext context) {
    if (cars.isEmpty) {
      return const Center(child: Text('Aucune voiture'));
    }
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
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
