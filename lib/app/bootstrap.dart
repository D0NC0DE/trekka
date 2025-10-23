import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/app/app.dart';
import 'package:trekka/app/di/auth_state_providers.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  final ProviderContainer container = ProviderContainer();

  await container.read(authStateProvider.notifier).initialize();

  runApp(
    UncontrolledProviderScope(container: container, child: const TrekkaApp()),
  );
}
