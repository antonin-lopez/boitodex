import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/car/domain/models/keyword.dart';
import 'package:boitodex/features/car_entry_detail/presentation/screens/car_entry_screen.dart';

void main() {
  group('CarEntryScreen', () {
    testWidgets(
      'should prefill notes and keywords when existingCar is provided',
      (tester) async {
        final existingCar = Car(
          id: 'car-1',
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
              home: CarEntryScreen(
                collectionId: 'collection-1',
                existingCar: existingCar,
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
