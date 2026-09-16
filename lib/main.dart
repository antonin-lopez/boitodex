import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/app.dart';
import 'package:boitodex/core/providers/core_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final container = ProviderContainer();
  await container.read(embeddingEngineProvider).initialize();

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
