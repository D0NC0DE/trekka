import 'package:flutter/material.dart';

import 'package:trekka/app/theme/app_theme.dart';
import 'package:trekka/features/placeholder/presentation/pages/placeholder_page.dart';

class TrekkaApp extends StatelessWidget {
  const TrekkaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trekka',
      theme: buildAppTheme(),
      home: const PlaceholderPage(),
    );
  }
}
