import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/compatibility_wizard.dart';
import 'services/supabase_manager.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    await dotenv.load(fileName: '.env.example');
  }
  await SupabaseManager.init(
    url: dotenv.env['SUPABASE_URL'],
    anonKey: dotenv.env['SUPABASE_ANON_KEY'],
  );
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
