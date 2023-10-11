import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeTexts {
  static TextTheme lightTheme = TextTheme(
      displayMedium: GoogleFonts.montserrat(
          color: Colors.black54
      ),
      titleSmall: GoogleFonts.poppins(
        color: Colors.black54,
        fontSize: 24,
      ),
  );
  static TextTheme darkTheme = TextTheme(
      displayMedium: GoogleFonts.montserrat(
          color: Colors.white70
      ),
      titleSmall: GoogleFonts.poppins(
        color: Colors.white70,
        fontSize: 24,
      ),
  );
}