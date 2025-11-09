
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primarySeedColor = Colors.green;

final TextTheme appTextTheme = TextTheme(
  displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
  titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
  bodyMedium: GoogleFonts.openSans(fontSize: 14),
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primarySeedColor,
    brightness: Brightness.light,
  ),
  textTheme: appTextTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: primarySeedColor,
    foregroundColor: Colors.white,
    titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: primarySeedColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),
);
