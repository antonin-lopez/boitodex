import 'package:boitodex/features/car_entry_detail/presentation/screens/car_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/features/car/data/providers/car_providers.dart';
import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/catalog_search/presentation/controllers/catalog_search_controller.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({required this.collectionId, super.key});

  final String collectionId;

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final _searchController = TextEditingController();
  var _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    final trimmed = query.trim();
    setState(() => _isSearching = trimmed.isNotEmpty);
    if (trimmed.isNotEmpty) {
      ref
          .read(catalogSearchControllerProvider(widget.collectionId).notifier)
          .search(trimmed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allCars = ref.watch(carsByCollectionProvider(widget.collectionId));
    final searchResults = ref.watch(
      catalogSearchControllerProvider(widget.collectionId),
    );

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Rechercher une voiture',
            border: InputBorder.none,
          ),
          onSubmitted: _search,
          onChanged: (value) {
            if (value.trim().isEmpty) _search(value);
          },
        ),
      ),
      body: _isSearching
          ? searchResults.when(
              data: (results) => _CarListView(
                cars: results.map((r) => r.car).toList(),
                scores: {for (final r in results) r.car.id: r.score},
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('$error')),
            )
          : allCars.when(
              data: (cars) => _CarListView(cars: cars),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('$error')),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CarEntryScreen(collectionId: widget.collectionId),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CarListView extends StatelessWidget {
  const _CarListView({required this.cars, this.scores});

  final List<Car> cars;
  final Map<String, double>? scores;

  @override
  Widget build(BuildContext context) {
    if (cars.isEmpty) {
      return const Center(child: Text('Aucune voiture'));
    }
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        final score = scores?[car.id];
        return ListTile(
          title: Text(
            car.keywords.isEmpty
                ? 'Sans mot-clé'
                : car.keywords.map((k) => k.label).join(', '),
          ),
          subtitle: car.notes == null ? null : Text(car.notes!),
          trailing: score == null ? null : Text(score.toStringAsFixed(2)),
        );
      },
    );
  }
}
