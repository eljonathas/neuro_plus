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
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.blueRibbon[500]!,
    brightness: Brightness.light,
    primary: AppColors.blueRibbon[500]!,
    onPrimary: Colors.white,
    primaryContainer: AppColors.blueRibbon[100]!,
    onPrimaryContainer: AppColors.blueRibbon[900]!,
    secondary: AppColors.blueRibbon[300]!,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.blueRibbon[50]!,
    onSecondaryContainer: AppColors.blueRibbon[800]!,
    surface: Colors.white,
    onSurface: AppColors.gray[900]!,
    surfaceContainerHighest: AppColors.gray[100]!,
    outline: AppColors.gray[300]!,
    outlineVariant: AppColors.gray[200]!,
  );

  final ThemeData appTheme = ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.gray[50],
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.gray[900]),
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.gray[900],
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blueRibbon[500],
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.blueRibbon[500];
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.blueRibbon[500];
        }
        return AppColors.gray[400];
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.blueRibbon[500];
        }
        return AppColors.gray[400];
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.blueRibbon[200];
        }
        return AppColors.gray[200];
      }),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.blueRibbon[500],
      inactiveTrackColor: AppColors.gray[300],
      thumbColor: AppColors.blueRibbon[500],
      overlayColor: AppColors.blueRibbon[100],
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.blueRibbon[500],
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.blueRibbon[500],
      foregroundColor: Colors.white,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: AppColors.blueRibbon[500],
      headerForegroundColor: Colors.white,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.gray[400]?.withAlpha(60);
        }
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return AppColors.gray[900];
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.blueRibbon[500];
        }
        return Colors.transparent;
      }),
      todayForegroundColor: WidgetStateProperty.all(AppColors.blueRibbon[500]),
      todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.gray[400]?.withAlpha(60);
        }
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return AppColors.gray[900];
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.blueRibbon[500];
        }
        return Colors.transparent;
      }),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      hourMinuteTextColor: Colors.white,
      hourMinuteColor: AppColors.blueRibbon[500],
      dayPeriodTextColor: Colors.white,
      dayPeriodColor: AppColors.blueRibbon[500],
      dialHandColor: AppColors.blueRibbon[500],
      dialBackgroundColor: AppColors.gray[100],
      dialTextColor: AppColors.gray[900],
      entryModeIconColor: AppColors.blueRibbon[500],
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: GoogleFonts.poppins(),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gray[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gray[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.blueRibbon[500]!),
        ),
      ),
    ),
  );

  return appTheme;
}
