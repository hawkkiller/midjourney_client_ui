import 'package:flutter/material.dart';
import 'package:midjourney_client_ui/src/core/localization/app_localization.dart';

extension LocalizationX on BuildContext {
  GeneratedLocalization stringOf() => AppLocalization.stringOf<GeneratedLocalization>(this);

  ThemeData themeOf() => Theme.of(this);

  TextTheme textThemeOf() => themeOf().textTheme;

  ColorScheme schemeOf() => themeOf().colorScheme;
}
