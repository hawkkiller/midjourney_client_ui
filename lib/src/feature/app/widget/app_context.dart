import 'package:flutter/material.dart';
import 'package:midjourney_client_ui/src/core/localization/app_localization.dart';
import 'package:midjourney_client_ui/src/core/theme/color_schemes.dart';
import 'package:midjourney_client_ui/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:midjourney_client_ui/src/feature/settings/widget/settings_scope.dart';

/// A widget which is responsible for providing the app context.
class AppContext extends StatelessWidget {
  const AppContext({super.key});

  @override
  Widget build(BuildContext context) {
    final router = DependenciesScope.of(context).router;
    return MaterialApp.router(
      routerConfig: router.config(),
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => SettingsScope(
        child: child!,
      ),
    );
  }
}
