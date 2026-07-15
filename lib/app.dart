import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/core/constants/app_constants.dart';
import 'package:boitodex/core/providers/theme_provider.dart';
import 'package:boitodex/core/theme/app_theme.dart';
import 'package:boitodex/features/catalog_search/presentation/screens/catalog_screen.dart';
import 'package:boitodex/features/onboarding_pairing/data/providers/onboarding_pairing_providers.dart';
import 'package:boitodex/features/onboarding_pairing/presentation/screens/onboarding_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const _Bootstrap(),
    );
  }
}

class _Bootstrap extends ConsumerWidget {
  const _Bootstrap();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCollection = ref.watch(activeCollectionProvider);

    return activeCollection.when(
      data: (collection) => collection == null
          ? const OnboardingScreen()
          : CatalogScreen(collectionId: collection.id),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text('$error'))),
    );
  }
}
