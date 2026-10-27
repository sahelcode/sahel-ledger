import 'package:flutter/material.dart';

/// Sahel Ledger design tokens.
abstract final class AppColors {
  // Brand
  static const navy900 = Color(0xFF081A33);
  static const navy800 = Color(0xFF0B2545);
  static const navy700 = Color(0xFF13315C);
  static const navy500 = Color(0xFF2F5C95);
  static const navy100 = Color(0xFFDCE6F5);
  static const navy50 = Color(0xFFF0F4FA);

  // Neutrals (slate)
  static const slate900 = Color(0xFF0F172A);
  static const slate700 = Color(0xFF334155);
  static const slate500 = Color(0xFF64748B);
  static const slate400 = Color(0xFF94A3B8);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate50 = Color(0xFFF8FAFC);

  // Semantic
  static const emerald600 = Color(0xFF047857);
  static const emerald500 = Color(0xFF059669);
  static const emerald100 = Color(0xFFD1FAE5);
  static const emerald300 = Color(0xFF6EE7B7);
  static const red600 = Color(0xFFB91C1C);
  static const red100 = Color(0xFFFEE2E2);
  static const red300 = Color(0xFFFCA5A5);
  static const amber600 = Color(0xFFB45309);
  static const amber100 = Color(0xFFFEF3C7);
  static const amber300 = Color(0xFFFCD34D);

  // Dark surfaces
  static const ink950 = Color(0xFF070D19);
  static const ink900 = Color(0xFF0C1527);
  static const ink800 = Color(0xFF131F36);
  static const ink700 = Color(0xFF1C2B47);
}

abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

abstract final class Radii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
}

const kFontFamily = 'HindSiliguri';

/// Semantic colours not covered by [ColorScheme].
@immutable
class LedgerColors extends ThemeExtension<LedgerColors> {
  const LedgerColors({
    required this.positive,
    required this.positiveContainer,
    required this.negative,
    required this.negativeContainer,
    required this.warning,
    required this.warningContainer,
    required this.muted,
    required this.border,
    required this.heroStart,
    required this.heroEnd,
  });

  final Color positive;
  final Color positiveContainer;
  final Color negative;
  final Color negativeContainer;
  final Color warning;
  final Color warningContainer;
  final Color muted;
  final Color border;
  final Color heroStart;
  final Color heroEnd;

  static const light = LedgerColors(
    positive: AppColors.emerald600,
    positiveContainer: AppColors.emerald100,
    negative: AppColors.red600,
    negativeContainer: AppColors.red100,
    warning: AppColors.amber600,
    warningContainer: AppColors.amber100,
    muted: AppColors.slate500,
    border: AppColors.slate200,
    heroStart: AppColors.navy800,
    heroEnd: AppColors.navy700,
  );

  static const dark = LedgerColors(
    positive: AppColors.emerald300,
    positiveContainer: Color(0xFF0B3B2E),
    negative: AppColors.red300,
    negativeContainer: Color(0xFF3F1515),
    warning: AppColors.amber300,
    warningContainer: Color(0xFF3B2A09),
    muted: AppColors.slate400,
    border: AppColors.ink700,
    heroStart: AppColors.ink800,
    heroEnd: AppColors.navy800,
  );

  @override
  LedgerColors copyWith() => this;

  @override
  LedgerColors lerp(LedgerColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return LedgerColors(
      positive: l(positive, other.positive),
      positiveContainer: l(positiveContainer, other.positiveContainer),
      negative: l(negative, other.negative),
      negativeContainer: l(negativeContainer, other.negativeContainer),
      warning: l(warning, other.warning),
      warningContainer: l(warningContainer, other.warningContainer),
      muted: l(muted, other.muted),
      border: l(border, other.border),
      heroStart: l(heroStart, other.heroStart),
      heroEnd: l(heroEnd, other.heroEnd),
    );
  }
}

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  LedgerColors get ledger => Theme.of(this).extension<LedgerColors>()!;
  TextTheme get text => Theme.of(this).textTheme;
}

/// Tabular figures keep amounts aligned in lists and tables.
const moneyFeatures = [FontFeature.tabularFigures()];

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = dark
      ? const ColorScheme.dark(
          primary: Color(0xFF9DBBEB),
          onPrimary: AppColors.navy900,
          primaryContainer: AppColors.navy700,
          onPrimaryContainer: AppColors.navy100,
          secondary: AppColors.emerald300,
          onSecondary: Color(0xFF00281C),
          surface: AppColors.ink900,
          onSurface: Color(0xFFE5EAF2),
          onSurfaceVariant: AppColors.slate400,
          surfaceContainerLowest: AppColors.ink950,
          surfaceContainerLow: AppColors.ink900,
          surfaceContainer: AppColors.ink800,
          surfaceContainerHigh: AppColors.ink700,
          surfaceContainerHighest: Color(0xFF243656),
          outline: Color(0xFF3A4D6E),
          outlineVariant: AppColors.ink700,
          error: AppColors.red300,
          onError: Color(0xFF3F1515),
        )
      : const ColorScheme.light(
          primary: AppColors.navy800,
          onPrimary: Colors.white,
          primaryContainer: AppColors.navy100,
          onPrimaryContainer: AppColors.navy900,
          secondary: AppColors.emerald500,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: AppColors.slate900,
          onSurfaceVariant: AppColors.slate500,
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: AppColors.slate50,
          surfaceContainer: AppColors.slate100,
          surfaceContainerHigh: AppColors.slate200,
          surfaceContainerHighest: AppColors.slate300,
          outline: AppColors.slate300,
          outlineVariant: AppColors.slate200,
          error: AppColors.red600,
          onError: Colors.white,
        );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: kFontFamily,
    brightness: brightness,
  );
  final text = base.textTheme.apply(
    bodyColor: scheme.onSurface,
    displayColor: scheme.onSurface,
  );
  final border = dark ? AppColors.ink700 : AppColors.slate200;
  return base.copyWith(
    scaffoldBackgroundColor: dark ? AppColors.ink950 : AppColors.slate50,
    extensions: [dark ? LedgerColors.dark : LedgerColors.light],
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      titleLarge: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: text.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      bodyLarge: text.bodyLarge?.copyWith(height: 1.45),
      bodyMedium: text.bodyMedium?.copyWith(height: 1.45),
      labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? AppColors.ink950 : AppColors.slate50,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
      titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.lg),
        side: BorderSide(color: border),
      ),
    ),
    dividerTheme: DividerThemeData(color: border, space: 1, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? AppColors.ink800 : Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: BorderSide(color: scheme.error),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        textStyle: text.labelLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      side: BorderSide(color: border),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        text.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.lg),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: Space.lg),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
