import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color kBg = Color(0xFF061826);
  static const Color kSurface = Color(0xFF0C2438);
  static const Color kAccent = Color(0xFF4FD1C5);
  static const Color kTerracotta = Color(0xFFFFB347);
  static const Color kAncientBlue = Color(0xFF7DD3FC);
  static const Color kParchment = Color(0xFFE6F4FF);
  static const Color kGlass = Color(0xFF11314A);
  static const Color kGlassBorder = Color(0xFF1D4B6A);

  static const Color primaryColor = kAccent;
  static const Color secondaryColor = kTerracotta;
  static const Color accentColor = kAccent;
  static const Color backgroundColor = kBg;
  static const Color surfaceColor = kSurface;
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color textDark = kParchment;
  static const Color textLight = Color(0xFFA9C4D8);
  static const Color textWhite = Colors.white;

  static const Color viewerColor = kAccent;
  static const Color contributorColor = kTerracotta;
  static const Color adminColor = kAncientBlue;

  static ThemeData get darkGlassTheme {
    final baseTextTheme = GoogleFonts.spaceGroteskTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kBg,
      colorScheme: const ColorScheme.dark(
        primary: kAccent,
        secondary: kTerracotta,
        tertiary: kAncientBlue,
        surface: kSurface,
        onPrimary: kBg,
        onSurface: kParchment,
        error: errorColor,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: baseTextTheme.displayMedium?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: baseTextTheme.displaySmall?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w700,
          fontSize: 30,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          color: kParchment,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: kParchment,
          height: 1.45,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: textLight,
          height: 1.4,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          color: kAccent,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: kParchment,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: kSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: kGlassBorder),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kGlass,
        selectedColor: kAccent.withValues(alpha: 0.18),
        secondarySelectedColor: kAccent.withValues(alpha: 0.18),
        labelStyle: GoogleFonts.spaceGrotesk(
          color: kParchment,
          fontWeight: FontWeight.w600,
        ),
        side: const BorderSide(color: kGlassBorder),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          foregroundColor: kBg,
          minimumSize: const Size(64, 54),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kParchment,
          side: const BorderSide(color: kGlassBorder),
          minimumSize: const Size(64, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kAccent,
          textStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kGlass,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: kGlassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: kGlassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: kAccent, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textLight),
        hintStyle: const TextStyle(color: textLight),
        prefixIconColor: kAccent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF081E2D),
        indicatorColor: kAccent.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.spaceGrotesk(
            color: kParchment,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: kParchment),
      dividerColor: kGlassBorder,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: kSurface,
        contentTextStyle: GoogleFonts.spaceGrotesk(color: kParchment),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
