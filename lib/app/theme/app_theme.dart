import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.2.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // Using FlexColorScheme built-in FlexScheme enum based colors
    scheme: FlexScheme.yellowM3,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      defaultRadius: 31.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    useMaterial3: false,
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Using FlexColorScheme built-in FlexScheme enum based colors.
    scheme: FlexScheme.yellowM3,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      defaultRadius: 31.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    useMaterial3: false,
  );
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sole_space_admin/app/theme/app_color.dart';

// class AppTheme {
//   static final ThemeData lightTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.light,
//     colorScheme: ColorScheme.light(
//       primary: Colors.blue.shade800,
//       secondary: Colors.blue.shade600,
//       surface: Colors.white,
//     ),
//     textTheme: GoogleFonts.poppinsTextTheme(),
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.blue.shade800,
//       foregroundColor: Colors.white,
//       elevation: 0,
//     ),
//     cardTheme: CardTheme(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     ),

//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         elevation: 0,
//         textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//       ),
//     ),
//   );

//   static final ThemeData darkTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,
//     colorScheme: ColorScheme.dark(
//       primary: Colors.blue.shade300,
//       secondary: Colors.blue.shade200,
//       surface: Colors.grey.shade900,
//     ),
//     textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.grey.shade900,
//       foregroundColor: Colors.white,
//       elevation: 0,
//     ),
//     cardTheme: CardTheme(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         elevation: 0,
//         textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//       ),
//     ),
//   );
// }
