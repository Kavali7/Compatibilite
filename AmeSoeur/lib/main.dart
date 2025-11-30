import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screens/html_flow_screen.dart';

void main() {
  runApp(const AmeSoeurApp());
}

class AmeSoeurApp extends StatelessWidget {
  const AmeSoeurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AmeSoeur',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HtmlFlowScreen(),
    );
  }
}
