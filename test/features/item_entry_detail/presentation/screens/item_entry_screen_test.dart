import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boitodex/features/item/domain/models/item.dart';
import 'package:boitodex/features/item/domain/models/keyword.dart';
import 'package:boitodex/features/item_entry_detail/presentation/screens/item_entry_screen.dart';

void main() {
  group('ItemEntryScreen', () {
    testWidgets(
      'should prefill notes and keywords when existingItem is provided',
      (tester) async {
        final existingItem = Item(
          id: 'item-1',
          collectionId: 'collection-1',
          notes: 'Notes existantes',
          keywords: [
            Keyword(
              id: 'kw-1',
              collectionId: 'collection-1',
              label: 'Ambulance',
              createdAt: DateTime.now(),
            ),
          ],
          images: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: ItemEntryScreen(
                collectionId: 'collection-1',
                existingItem: existingItem,
              ),
            ),
          ),
        );

        expect(find.text('Notes existantes'), findsOneWidget);
        expect(find.text('Ambulance'), findsOneWidget);
        expect(find.text('Modifier la voiture'), findsOneWidget);
      },
    );
  });
}
