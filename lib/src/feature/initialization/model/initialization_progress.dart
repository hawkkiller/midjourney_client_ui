import 'package:midjourney_client_ui/src/feature/initialization/model/dependencies.dart';
import 'package:midjourney_client_ui/src/feature/initialization/model/environment_store.dart';

/// Initialization progress
final class InitializationProgress {
  /// Instantiates a new [InitializationProgress]
  InitializationProgress(this.environmentStore);

  /// Mutable Dependencies
  final dependencies = Dependencies$Mutable();

  /// Environment store
  final EnvironmentStore environmentStore;

  /// Freeze dependencies, so they cannot be modified
  Dependencies freeze() => dependencies.freeze();
}
