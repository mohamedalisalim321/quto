import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.black, // Buttons, highlights
      onPrimary: Colors.white, // Text on primary
      secondary: Colors.grey.shade600, // Accents
      onSecondary: Colors.white,
      surface: Colors.grey.shade100, // Cards, surfaces
      onSurface: Colors.black87,
      shadow: Colors.black26,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    cardColor: Colors.grey.shade100,
    dividerColor: Colors.black26,
    splashColor: Colors.black12,
    highlightColor: Colors.black12,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black87,
      selectionHandleColor: Colors.black54,
      selectionColor: Colors.black12,
    ),
    shadowColor: Colors.black26,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
      titleMedium: TextStyle(color: Colors.black87),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.dark(
      primary: Colors.white, // Buttons, highlights
      onPrimary: Colors.black,
      secondary: Colors.grey.shade400, // Accents
      onSecondary: Colors.black,
      surface: const Color(0xFF1E1E1E), // Cards, surfaces
      onSurface: Colors.white,
      shadow: Colors.black54,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: Colors.white24,
    splashColor: Colors.white12,
    highlightColor: Colors.white10,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionHandleColor: Colors.white70,
      selectionColor: Colors.white12,
    ),
    shadowColor: Colors.black54,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white70,
      foregroundColor: Colors.black87,
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
      titleMedium: TextStyle(color: Colors.white),
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// /// Centralized theme configuration for the Quotes app
// ///
// /// Features:
// /// - ✅ Full Material 3 color scheme with semantic tokens
// /// - ✅ Comprehensive component theming (buttons, cards, inputs, dialogs)
// /// - ✅ Accessible typography with dynamic type support
// /// - ✅ Quote-specific UI components (quote cards, author badges)
// /// - ✅ Platform-aware adjustments (iOS cupertino feel, Android material)
// /// - ✅ Customizable via builder pattern for runtime theming
// class AppThemes {
//   AppThemes._();

//   // ================= COLOR PALETTES =================

//   // Light theme colors
//   static const _lightPrimary = Color(0xFF1A1A1A);
//   static const _lightPrimaryContainer = Color(0xFFE0E0E0);
//   static const _lightSecondary = Color(0xFF6B6B6B);
//   static const _lightSurface = Color(0xFFF8F9FA);
//   static const _lightSurfaceVariant = Color(0xFFECECEC);
//   static const _lightError = Color(0xFFB3261E);
//   static const _lightOnPrimary = Colors.white;
//   static const _lightOnSecondary = Colors.white;
//   static const _lightOnSurface = Color(0xFF1A1A1A);
//   static const _lightOnSurfaceVariant = Color(0xFF424242);

//   // Dark theme colors
//   static const _darkPrimary = Color(0xFFE0E0E0);
//   static const _darkPrimaryContainer = Color(0xFF424242);
//   static const _darkSecondary = Color(0xFFB0B0B0);
//   static const _darkSurface = Color(0xFF121212);
//   static const _darkSurfaceVariant = Color(0xFF1E1E1E);
//   static const _darkError = Color(0xFFCF6679);
//   static const _darkOnPrimary = Color(0xFF1A1A1A);
//   static const _darkOnSecondary = Color(0xFF1A1A1A);
//   static const _darkOnSurface = Color(0xFFE0E0E0);
//   static const _darkOnSurfaceVariant = Color(0xFFB0B0B0);

//   // Accent colors for quote categories
//   static const _accentInspiration = Color(0xFF8B5CF6); // Purple

//   // ================= PUBLIC GETTERS =================

//   /// Light theme with full Material 3 configuration
//   static ThemeData get lightTheme => _buildTheme(
//         brightness: Brightness.light,
//         primary: _lightPrimary,
//         primaryContainer: _lightPrimaryContainer,
//         secondary: _lightSecondary,
//         surface: _lightSurface,
//         surfaceVariant: _lightSurfaceVariant,
//         error: _lightError,
//         onPrimary: _lightOnPrimary,
//         onSecondary: _lightOnSecondary,
//         onSurface: _lightOnSurface,
//         onSurfaceVariant: _lightOnSurfaceVariant,
//       );

//   /// Dark theme with full Material 3 configuration
//   static ThemeData get darkTheme => _buildTheme(
//         brightness: Brightness.dark,
//         primary: _darkPrimary,
//         primaryContainer: _darkPrimaryContainer,
//         secondary: _darkSecondary,
//         surface: _darkSurface,
//         surfaceVariant: _darkSurfaceVariant,
//         error: _darkError,
//         onPrimary: _darkOnPrimary,
//         onSecondary: _darkOnSecondary,
//         onSurface: _darkOnSurface,
//         onSurfaceVariant: _darkOnSurfaceVariant,
//       );

//   // ================= THEME BUILDER =================

//   /// Build a complete ThemeData with Material 3 best practices
//   static ThemeData _buildTheme({
//     required Brightness brightness,
//     required Color primary,
//     required Color primaryContainer,
//     required Color secondary,
//     required Color surface,
//     required Color surfaceVariant,
//     required Color error,
//     required Color onPrimary,
//     required Color onSecondary,
//     required Color onSurface,
//     required Color onSurfaceVariant,
//   }) {
//     final isDark = brightness == Brightness.dark;
//     final colorScheme = ColorScheme(
//       brightness: brightness,
//       primary: primary,
//       onPrimary: onPrimary,
//       primaryContainer: primaryContainer,
//       onPrimaryContainer: isDark ? _darkOnSurface : _lightOnSurface,
//       secondary: secondary,
//       onSecondary: onSecondary,
//       secondaryContainer: isDark ? _darkSurfaceVariant : _lightSurfaceVariant,
//       onSecondaryContainer:
//           isDark ? _darkOnSurfaceVariant : _lightOnSurfaceVariant,
//       surface: surface,
//       onSurface: onSurface,
//       surfaceContainerHighest: surfaceVariant,
//       onSurfaceVariant: onSurfaceVariant,
//       error: error,
//       onError: isDark ? Colors.white : Colors.black,
//       outline: isDark ? const Color(0xFF757575) : const Color(0xFF757575),
//       outlineVariant:
//           isDark ? const Color(0xFF424242) : const Color(0xFFBDBDBD),
//       shadow: isDark ? Colors.black54 : Colors.black26,
//       scrim: Colors.black87,
//       inverseSurface: isDark ? _lightSurface : _darkSurface,
//       onInverseSurface: isDark ? _lightOnSurface : _darkOnSurface,
//       inversePrimary: isDark ? _lightPrimary : _darkPrimary,
//     );

//     return ThemeData(
//       useMaterial3: true,
//       brightness: brightness,
//       colorScheme: colorScheme,

//       // ================= SURFACE & BACKGROUND =================
//       scaffoldBackgroundColor: surface,
//       canvasColor: surface,
//       cardColor: surfaceVariant,
//       dialogBackgroundColor: surfaceVariant,
//       bottomSheetTheme: BottomSheetThemeData(
//         backgroundColor: surfaceVariant,
//         modalBackgroundColor: surfaceVariant.withOpacity(0.95),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//         ),
//       ),

//       // ================= APP BAR =================
//       appBarTheme: AppBarTheme(
//         backgroundColor: surface,
//         foregroundColor: onSurface,
//         elevation: 0,
//         centerTitle: true,
//         scrolledUnderElevation: 2,
//         shadowColor: colorScheme.shadow,
//         surfaceTintColor: Colors.transparent,
//         titleTextStyle: _textTheme.titleLarge?.copyWith(
//           fontWeight: FontWeight.w700,
//           color: onSurface,
//         ),
//         iconTheme: IconThemeData(
//           color: onSurface,
//           size: 24,
//         ),
//         actionsIconTheme: IconThemeData(
//           color: onSurfaceVariant,
//           size: 24,
//         ),
//         systemOverlayStyle:
//             isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
//       ),

//       // ================= TYPOGRAPHY =================
//       textTheme: _buildTextTheme(brightness, onSurface, onSurfaceVariant),
//       primaryTextTheme: _buildTextTheme(brightness, onPrimary, onSecondary),

//       // ================= BUTTONS =================
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primary,
//           foregroundColor: onPrimary,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 2,
//           textStyle: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//             letterSpacing: 0.1,
//           ),
//         ),
//       ),
//       filledButtonTheme: FilledButtonThemeData(
//         style: FilledButton.styleFrom(
//           backgroundColor: primaryContainer,
//           foregroundColor: onSurface,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: onSurface,
//           side: BorderSide(color: onSurfaceVariant.withOpacity(0.5)),
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: secondary,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           textStyle: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//       ),
//       iconButtonTheme: IconButtonThemeData(
//         style: IconButton.styleFrom(
//           foregroundColor: onSurfaceVariant,
//           padding: const EdgeInsets.all(12),
//         ),
//       ),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: primary,
//         foregroundColor: onPrimary,
//         elevation: 4,
//         highlightElevation: 8,
//         shape: const CircleBorder(),
//       ),

//       // ================= CARDS & SURFACES =================
//       cardTheme: CardTheme(
//         color: surfaceVariant,
//         elevation: isDark ? 2 : 1,
//         shadowColor: colorScheme.shadow,
//         surfaceTintColor: Colors.transparent,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: BorderSide(
//             color: onSurfaceVariant.withOpacity(0.1),
//             width: 1,
//           ),
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         clipBehavior: Clip.antiAlias,
//       ),

//       // ================= INPUTS =================
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: surfaceVariant,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: onSurfaceVariant.withOpacity(0.3)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: onSurfaceVariant.withOpacity(0.3)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: primary, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFB3261E), width: 2),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFB3261E), width: 2),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         hintStyle: TextStyle(
//           color: onSurfaceVariant.withOpacity(0.7),
//           fontWeight: FontWeight.w400,
//         ),
//         labelStyle: TextStyle(
//           color: onSurfaceVariant,
//           fontWeight: FontWeight.w500,
//         ),
//         floatingLabelStyle: TextStyle(
//           color: primary,
//           fontWeight: FontWeight.w600,
//         ),
//         errorStyle: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//         prefixIconColor: onSurfaceVariant,
//         suffixIconColor: onSurfaceVariant,
//       ),

//       // ================= DIALOGS & ALERTS =================
//       dialogTheme: DialogTheme(
//         backgroundColor: surfaceVariant,
//         surfaceTintColor: Colors.transparent,
//         elevation: isDark ? 8 : 4,
//         shadowColor: colorScheme.shadow,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         titleTextStyle: _textTheme.titleLarge?.copyWith(
//           fontWeight: FontWeight.w700,
//           color: onSurface,
//         ),
//         contentTextStyle: _textTheme.bodyLarge?.copyWith(
//           color: onSurfaceVariant,
//         ),
//         actionsPadding: const EdgeInsets.only(
//           bottom: 16,
//           right: 16,
//           left: 16,
//         ),
//       ),
//       snackBarTheme: SnackBarThemeData(
//         backgroundColor:
//             isDark ? const Color(0xFF323232) : const Color(0xFF323232),
//         contentTextStyle: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w500,
//         ),
//         actionTextColor: _accentInspiration,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         behavior: SnackBarBehavior.floating,
//         elevation: 6,
//       ),

//       // ================= LISTS & DIVIDERS =================
//       dividerColor: onSurfaceVariant.withOpacity(0.15),
//       dividerTheme: DividerThemeData(
//         color: onSurfaceVariant.withOpacity(0.15),
//         thickness: 1,
//         space: 1,
//       ),
//       listTileTheme: ListTileThemeData(
//         iconColor: onSurfaceVariant,
//         textColor: onSurface,
//         titleTextStyle: _textTheme.titleMedium?.copyWith(
//           fontWeight: FontWeight.w600,
//         ),
//         subtitleTextStyle: _textTheme.bodyMedium?.copyWith(
//           color: onSurfaceVariant,
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         tileColor: surfaceVariant,
//         selectedTileColor: primaryContainer.withOpacity(0.3),
//       ),

//       // ================= SELECTION & INTERACTION =================
//       splashFactory: InkRipple.splashFactory,
//       splashColor: primary.withOpacity(0.1),
//       highlightColor: primary.withOpacity(0.05),
//       hoverColor: primary.withOpacity(0.08),

//       textSelectionTheme: TextSelectionThemeData(
//         cursorColor: primary,
//         selectionColor: primary.withOpacity(0.4),
//         selectionHandleColor: primary,
//       ),

//       // ================= PROGRESS & INDICATORS =================
//       progressIndicatorTheme: ProgressIndicatorThemeData(
//         color: primary,
//         linearTrackColor: onSurfaceVariant.withOpacity(0.2),
//         circularTrackColor: onSurfaceVariant.withOpacity(0.2),
//       ),

//       // ================= CHIPS & FILTERS =================
//       chipTheme: ChipThemeData(
//         backgroundColor: surfaceVariant,
//         disabledColor: onSurfaceVariant.withOpacity(0.3),
//         selectedColor: primaryContainer,
//         secondarySelectedColor: primaryContainer,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         labelStyle: TextStyle(
//           color: onSurface,
//           fontWeight: FontWeight.w500,
//           fontSize: 13,
//         ),
//         secondaryLabelStyle: TextStyle(
//           color: onPrimary,
//           fontWeight: FontWeight.w500,
//           fontSize: 13,
//         ),
//         brightness: brightness,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: BorderSide(
//             color: onSurfaceVariant.withOpacity(0.3),
//             width: 1,
//           ),
//         ),
//       ),

//       // ================= BADGES =================
//       badgeTheme: BadgeThemeData(
//         backgroundColor: error,
//         textColor: Colors.white,
//         largeSize: 20,
//         smallSize: 16,
//         textStyle: const TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 11,
//         ),
//       ),

//       // ================= ANIMATIONS & TRANSITIONS =================
//       pageTransitionsTheme: const PageTransitionsTheme(
//         builders: {
//           TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
//           TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//           TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
//           TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
//           TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
//         },
//       ),
//       visualDensity: VisualDensity.adaptivePlatformDensity,
//       materialTapTargetSize:
//           MaterialTapTargetSize.padded, // Better touch targets

//       // ================= ACCESSIBILITY =================
//       // Ensure minimum contrast ratios are met
//       // (Material 3 color scheme handles this, but we verify)
//     ).copyWith(
//       // Ensure toggle switches use primary color
//       switchTheme: SwitchThemeData(
//         thumbColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) return primary;
//           return onSurfaceVariant;
//         }),
//         trackColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) {
//             return primary.withOpacity(0.5);
//           }
//           return onSurfaceVariant.withOpacity(0.3);
//         }),
//       ),
//       // Radio and checkbox theming
//       checkboxTheme: CheckboxThemeData(
//         fillColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) return primary;
//           return null;
//         }),
//         checkColor: WidgetStateProperty.all(onPrimary),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ),
//       radioTheme: RadioThemeData(
//         fillColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) return primary;
//           return null;
//         }),
//       ),
//     );
//   }

//   // ================= TYPOGRAPHY =================

//   /// Build accessible text theme with proper hierarchy
//   static TextTheme _buildTextTheme(
//     Brightness brightness,
//     Color onSurface,
//     Color onSurfaceVariant,
//   ) {
//     final base = brightness == Brightness.dark
//         ? Typography.englishLike2021.merge(Typography.whiteMountainView)
//         : Typography.englishLike2021.merge(Typography.blackMountainView);

//     return base.copyWith(
//       // Display styles (for hero sections, empty states)
//       displayLarge: base.displayLarge?.copyWith(
//         fontWeight: FontWeight.w800,
//         color: onSurface,
//         height: 1.1,
//         letterSpacing: -0.5,
//       ),
//       displayMedium: base.displayMedium?.copyWith(
//         fontWeight: FontWeight.w700,
//         color: onSurface,
//         height: 1.15,
//       ),
//       displaySmall: base.displaySmall?.copyWith(
//         fontWeight: FontWeight.w700,
//         color: onSurface,
//         height: 1.2,
//       ),

//       // Headline styles (section titles, quote authors)
//       headlineLarge: base.headlineLarge?.copyWith(
//         fontWeight: FontWeight.w700,
//         color: onSurface,
//         height: 1.25,
//       ),
//       headlineMedium: base.headlineMedium?.copyWith(
//         fontWeight: FontWeight.w600,
//         color: onSurface,
//         height: 1.3,
//       ),
//       headlineSmall: base.headlineSmall?.copyWith(
//         fontWeight: FontWeight.w600,
//         color: onSurface,
//         height: 1.35,
//       ),

//       // Title styles (card titles, app bar)
//       titleLarge: base.titleLarge?.copyWith(
//         fontWeight: FontWeight.w700,
//         color: onSurface,
//         height: 1.4,
//       ),
//       titleMedium: base.titleMedium?.copyWith(
//         fontWeight: FontWeight.w600,
//         color: onSurface,
//         height: 1.4,
//       ),
//       titleSmall: base.titleSmall?.copyWith(
//         fontWeight: FontWeight.w500,
//         color: onSurfaceVariant,
//         height: 1.45,
//       ),

//       // Body styles (quote text, descriptions)
//       bodyLarge: base.bodyLarge?.copyWith(
//         fontWeight: FontWeight.w400,
//         color: onSurface,
//         height: 1.6, // Better readability for long text
//         letterSpacing: 0.15,
//       ),
//       bodyMedium: base.bodyMedium?.copyWith(
//         fontWeight: FontWeight.w400,
//         color: onSurface,
//         height: 1.5,
//         letterSpacing: 0.1,
//       ),
//       bodySmall: base.bodySmall?.copyWith(
//         fontWeight: FontWeight.w400,
//         color: onSurfaceVariant,
//         height: 1.45,
//       ),

//       // Label styles (buttons, chips, captions)
//       labelLarge: base.labelLarge?.copyWith(
//         fontWeight: FontWeight.w600,
//         color: onSurface,
//         height: 1.4,
//         letterSpacing: 0.1,
//       ),
//       labelMedium: base.labelMedium?.copyWith(
//         fontWeight: FontWeight.w500,
//         color: onSurfaceVariant,
//         height: 1.4,
//         letterSpacing: 0.1,
//       ),
//       labelSmall: base.labelSmall?.copyWith(
//         fontWeight: FontWeight.w500,
//         color: onSurfaceVariant,
//         height: 1.45,
//         letterSpacing: 0.2,
//       ),
//     );
//   }

//   /// Cached text theme for performance
//   static final TextTheme _textTheme = _buildTextTheme(
//     Brightness.light,
//     _lightOnSurface,
//     _lightOnSurfaceVariant,
//   );
// }
