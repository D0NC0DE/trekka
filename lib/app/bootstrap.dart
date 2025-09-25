import 'package:flutter/widgets.dart';

import 'package:trekka/app/app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const TrekkaApp());
}
