import 'package:flutter/material.dart';
import 'package:ppc/color_scheme/color_schemes.g.dart';

final universalTheme = _getTheme();
ThemeData _getTheme() {
  final base = ThemeData(colorScheme: darkColorScheme);
  return base.copyWith(
    textTheme: _getTextTheme(base.textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: base.colorScheme.primary,
      foregroundColor: base.colorScheme.onPrimary,
    ),
    scaffoldBackgroundColor: base.colorScheme.background,
    cardTheme: base.cardTheme.copyWith(
      color: base.colorScheme.primaryContainer,
    ),
  );
}

TextTheme _getTextTheme(TextTheme base) => base.copyWith(
    headlineLarge: base.headlineLarge!.copyWith(
      fontFamily: 'IvyMode',
      fontSize: 40,
      color: const Color.fromRGBO(224, 171, 67, 1),
    ),
    headlineMedium: base.headlineMedium!.copyWith(
      fontFamily: 'IvyMode',
      fontSize: 29,
      color: const Color.fromRGBO(224, 171, 67, 1),
    ),
    bodyLarge: base.bodyLarge!.copyWith(
      fontFamily: 'Switzer',
      fontSize: 17,
      color: const Color.fromRGBO(224, 171, 67, 1),
    ),
    bodyMedium: base.bodyMedium!.copyWith(
      fontFamily: 'Switzer',
      fontSize: 17,
      color: const Color.fromRGBO(159, 159, 159, 1),
    ),
    bodySmall: base.bodySmall!.copyWith(
      fontFamily: 'Switzer',
      fontSize: 12,
      color: const Color.fromRGBO(100, 100, 100, 1),
    ));
