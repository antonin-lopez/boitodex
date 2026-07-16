import 'package:boitodex/features/car_entry_detail/presentation/screens/car_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/core/constants/app_constants.dart';
import 'package:boitodex/core/theme/app_radius.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/widgets/empty_state.dart';
import 'package:boitodex/features/car/data/providers/car_providers.dart';
import 'package:boitodex/features/catalog_search/presentation/controllers/catalog_search_controller.dart';
import 'package:boitodex/features/catalog_search/presentation/widgets/car_grid_view.dart';

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

  void _clearSearch() {
    _searchController.clear();
    _search('');
  }

  @override
  Widget build(BuildContext context) {
    final allCars = ref.watch(carsByCollectionProvider(widget.collectionId));
    final searchResults = ref.watch(
      catalogSearchControllerProvider(widget.collectionId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Rechercher une voiture',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: _search,
              onChanged: (value) {
                if (value.trim().isEmpty) _search(value);
              },
            ),
          ),
          Expanded(
            child: _isSearching
                ? searchResults.when(
                    data: (results) => results.isEmpty
                        ? const EmptyState(
                            icon: Icons.search_off,
                            message: 'Aucun résultat pour cette recherche',
                          )
                        : CarGridView(
                            cars: results.map((r) => r.car).toList(),
                            scores: {
                              for (final r in results) r.car.id: r.score,
                            },
                          ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text('$error')),
                  )
                : allCars.when(
                    data: (cars) => CarGridView(cars: cars),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text('$error')),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CarEntryScreen(collectionId: widget.collectionId),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }
}
