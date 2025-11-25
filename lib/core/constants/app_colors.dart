import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background colors
  static const Color background = Color(0xFFF5F5F7);
  static const Color surface = Color(0xFFFFFFFF);

  // Cell colors
  static const Color cellHidden = Color(0xFFE8E8ED);
  static const Color cellRevealed = Color(0xFFFAFAFC);
  static const Color cellFlagged = Color(0xFFFFF3E0);
  static const Color cellExploded = Color(0xFFFFEBEE);
  static const Color cellBorder = Color(0xFFD0D0D5);

  // Shadow colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x26000000);

  // Number colors (classic minesweeper, slightly muted for modern look)
  static const List<Color> numberColors = [
    Colors.transparent, // 0 - not displayed
    Color(0xFF5C7AEA), // 1 - Soft blue
    Color(0xFF4CAF50), // 2 - Muted green
    Color(0xFFE57373), // 3 - Soft red
    Color(0xFF3949AB), // 4 - Dark blue
    Color(0xFF8D6E63), // 5 - Soft maroon
    Color(0xFF26A69A), // 6 - Muted cyan
    Color(0xFF424242), // 7 - Dark gray
    Color(0xFF9E9E9E), // 8 - Medium gray
  ];

  // Accent colors
  static const Color mine = Color(0xFF37474F);
  static const Color flag = Color(0xFFFF7043);
  static const Color explosion = Color(0xFFFF5722);
  static const Color explosionGlow = Color(0xFFFFAB91);

  // UI elements
  static const Color headerBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color divider = Color(0xFFECEFF1);

  // Win state
  static const Color winBackground = Color(0xFFE8F5E9);
  static const Color winAccent = Color(0xFF66BB6A);
}
