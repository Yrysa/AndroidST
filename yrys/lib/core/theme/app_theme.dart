// made by Yrysa
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: isDark ? AppColors.primaryDark : AppColors.primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? AppColors.darkBackgroundTop : AppColors.lightBackgroundTop,
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.display,
        headlineMedium: AppTextStyles.title,
        titleMedium: AppTextStyles.subtitle,
        bodyLarge: AppTextStyles.body,
        labelLarge: AppTextStyles.caption,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: AppTextStyles.caption.copyWith(fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: AppTextStyles.caption.copyWith(fontSize: 14),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
