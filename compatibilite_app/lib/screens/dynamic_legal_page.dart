import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/legal_models.dart';
import '../services/app_settings_service.dart';
import '../theme/app_theme.dart';

class DynamicLegalPage extends StatelessWidget {
  final LegalPage page;

  const DynamicLegalPage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          page.title,
          style: GoogleFonts.philosopher(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.block,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, Color(0xFF0E1E2A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.block.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: MarkdownBody(
              data: _processContent(page.content),
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(color: AppColors.textMuted, height: 1.5, fontSize: 15),
                h1: GoogleFonts.philosopher(color: AppColors.textLight, fontSize: 24, fontWeight: FontWeight.bold),
                h2: GoogleFonts.philosopher(color: AppColors.textLight, fontSize: 20, fontWeight: FontWeight.bold),
                h3: GoogleFonts.philosopher(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
                strong: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w700),
                listBullet: const TextStyle(color: AppColors.primary),
                blockSpacing: 16,
              ),
              selectable: true,
            ),
          ),
        ),
      ),
    );
  }

  String _processContent(String content) {
    final settings = AppSettingsService.instance;
    return content
        .replaceAll('{{EMAIL}}', settings.contactEmail)
        .replaceAll('{{WHATSAPP}}', settings.contactWhatsApp);
  }
}
