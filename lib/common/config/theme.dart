import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Map<int, Color> gray = {
    50: Color(0xFFF6F6F6),
    100: Color(0xFFE7E7E7),
    200: Color(0xFFD1D1D1),
    300: Color(0xFFB0B0B0),
    400: Color(0xFF888888),
    500: Color(0xFF6D6D6D),
    600: Color(0xFF5D5D5D),
    700: Color(0xFF4F4F4F),
    800: Color(0xFF454545),
    900: Color(0xFF3D3D3D),
    950: Color(0xFF000000),
  };
  static const Map<int, Color> blueRibbon = {
    50: Color(0xFFECF5FF),
    100: Color(0xFFDDECFF),
    200: Color(0xFFC2DBFF),
    300: Color(0xFF9CC2FF),
    400: Color(0xFF759DFF),
    500: Color(0xFF446DFF),
    600: Color(0xFF3651F5),
    700: Color(0xFF2A3FD8),
    800: Color(0xFF2538AE),
    900: Color(0xFF263789),
    950: Color(0xFF161D50),
  };
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF446DFF,
    blueRibbon,
  );
}

ThemeData generateTheme(BuildContext context) {
  final ThemeData appTheme = ThemeData(
    primarySwatch: AppColors.primarySwatch,
    scaffoldBackgroundColor: AppColors.gray[50],
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF3D3D3D)),
    ),
  );

  return appTheme;
}
