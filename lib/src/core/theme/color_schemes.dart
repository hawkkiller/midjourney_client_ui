import 'package:flutter/material.dart';

final lightThemeData = ThemeData(
  colorScheme: lightColorScheme,
  brightness: Brightness.light,
  useMaterial3: true,
);

final darkThemeData = ThemeData(
  colorScheme: darkColorScheme,
  brightness: Brightness.dark,
  useMaterial3: true,
);

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.dark,
);
