import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class MenuEntry {
  const MenuEntry({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;
}

class HamburgerMenuOverlay extends StatelessWidget {
  const HamburgerMenuOverlay({
    super.key,
    required this.isOpen,
    required this.onToggle,
    required this.entries,
    this.isDark = true,
  });

  final bool isOpen;
  final bool isDark;
  final VoidCallback onToggle;
  final List<MenuEntry> entries;

  @override
  Widget build(BuildContext context) {
    final menuBg = isDark ? AppColors.block : Colors.white;
    final textColor = isDark ? AppColors.accentText : Colors.black87;
    final iconColor = isDark ? AppColors.textLight : const Color(0xFF2D2D2D);

    return Stack(
      children: [
        if (!isOpen)
          Positioned(
            top: 16,
            right: 20,
            child: _circleButton(
              icon: Icons.menu,
              color: iconColor,
              onTap: onToggle,
            ),
          ),
        IgnorePointer(
          ignoring: !isOpen,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isOpen ? 1 : 0,
            child: GestureDetector(
              onTap: onToggle,
              child: Container(
                color: const Color(0xFF2F2F2F).withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: 0,
          bottom: 0,
          right: isOpen ? 0 : -320,
          child: Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              color: menuBg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(-4, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu',
                      style: GoogleFonts.philosopher(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    _circleButton(
                      icon: Icons.close,
                      color: iconColor,
                      onTap: onToggle,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: textColor.withValues(alpha: 0.25)),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          onToggle();
                          entry.onTap?.call();
                        },
                        title: Text(
                          entry.label,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.5,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: textColor.withValues(alpha: 0.8),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.15),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : const Color(0xFFE0E0E0),
            ),
          ),
          child: Icon(icon, color: color),
        ),
      ),
    );
  }
}
