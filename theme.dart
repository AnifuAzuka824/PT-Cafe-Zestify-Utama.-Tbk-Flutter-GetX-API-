import 'package:flutter/material.dart';

class ZestifyColors {
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF9E076);
  static const Color bg = Color(0xFF0A0A0A);
  static const Color card = Color(0xFF131313);
  static const Color surface = Color(0xFF111111);
  static const Color input = Color(0xFF1A1A1A);
  static const Color text = Color(0xFFEDEDED);
  static const Color textMuted = Color(0xFFAAAAAA);
  static const Color border = Color(0xFF2A2A2A);
  static const Color price = Color(0xFFF5E6B0);
  static const Color red = Color(0xFFE74C3C);
  static const Color green = Color(0xFF27AE60);
  static const Color food = Color(0xFFE67E22);
  static const Color drink = Color(0xFF5DADE2);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldLight, gold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class ZestifyTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ZestifyColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: ZestifyColors.gold,
          secondary: ZestifyColors.goldLight,
          surface: ZestifyColors.surface,
          onPrimary: ZestifyColors.bg,
          onSurface: ZestifyColors.text,
          error: ZestifyColors.red,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ZestifyColors.bg,
          foregroundColor: ZestifyColors.text,
          elevation: 0,
          centerTitle: true,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: ZestifyColors.gold,
        ),
      );
}
