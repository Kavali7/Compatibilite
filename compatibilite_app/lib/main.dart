import 'package:flutter/material.dart';

import 'screens/compatibility_wizard.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CompatibiliteApp());
}

class CompatibiliteApp extends StatelessWidget {
  const CompatibiliteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compatibilité & Guidance',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const CompatibilityWizard(),
    );
  }
}
