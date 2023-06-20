import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:midjourney_client_ui/src/core/widget/scope_widgets.dart';
import 'package:midjourney_client_ui/src/feature/app/widget/app_context.dart';
import 'package:midjourney_client_ui/src/feature/initialization/model/dependencies.dart';
import 'package:midjourney_client_ui/src/feature/initialization/widget/dependencies_scope.dart';

/// A widget which is responsible for running the app.
class App extends StatelessWidget {
  const App({
    required this.result,
    super.key,
  });

  void run() => runApp(
        DefaultAssetBundle(
          bundle: SentryAssetBundle(),
          child: this,
        ),
      );

  final InitializationResult result;

  @override
  Widget build(BuildContext context) => ScopeProvider(
        buildScope: (child) => DependenciesScope(
          dependencies: result.dependencies,
          child: child,
        ),
        child: const AppContext(),
      );
}
