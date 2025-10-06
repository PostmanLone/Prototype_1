import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette {
  static const Color deepGreen = Color(0xFF2C3930); // #2C3930
  static const Color forest = Color(0xFF3F4F44); // #3F4F44
  static const Color accent = Color(0xFFA27B5C); // #A27B5C
  static const Color sand = Color(0xFFDCD7C9); // #DCD7C9
  static const Color clay = Color(0xFFA27B5C);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Palette.forest,
        onPrimary: Colors.white,
        secondary: Palette.accent,
        onSecondary: Colors.white,
        error: Color(0xFFB00020),
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xFF1F2937),
      ),
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        headlineSmall: GoogleFonts.inter(fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w700),
      ),
      scaffoldBackgroundColor: Palette.sand,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: base.colorScheme.onSurface,
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Palette.sand,
        selectedColor: Palette.accent,
        labelStyle: const TextStyle(color: Color(0xFF1F2937)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Palette.forest,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Palette.forest,
          side: const BorderSide(color: Palette.forest, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      iconTheme: const IconThemeData(color: Palette.forest),
      dividerColor: Palette.sand,
    );
  }
}
