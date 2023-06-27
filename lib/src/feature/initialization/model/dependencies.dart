import 'package:database/database.dart';
import 'package:midjourney_client/midjourney_client.dart';
import 'package:midjourney_client_ui/src/core/router/router.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/messages_repository.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/midjourney_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dependencies container
abstract interface class Dependencies {
  /// Shared preferences
  abstract final SharedPreferences sharedPreferences;

  /// App router
  abstract final AppRouter router;

  /// Midjourney client
  abstract final Midjourney midjourneyClient;

  /// Midjourney Repository
  abstract final MidjourneyRepository midjourneyRepository;

  /// Database
  abstract final AppDatabase database;

  /// Messages Repository
  abstract final MessagesRepository messagesRepository;

  /// Freeze dependencies, so they cannot be modified
  Dependencies freeze();
}

/// Mutable version of dependencies
///
/// Used to build dependencies
final class Dependencies$Mutable implements Dependencies {
  Dependencies$Mutable();

  @override
  late SharedPreferences sharedPreferences;

  @override
  late AppRouter router;

  @override
  late Midjourney midjourneyClient;

  @override
  late MidjourneyRepository midjourneyRepository;

  @override
  late AppDatabase database;

  @override
  late MessagesRepository messagesRepository;

  @override
  Dependencies freeze() => _Dependencies$Immutable(
        sharedPreferences: sharedPreferences,
        router: router,
        database: database,
        midjourneyClient: midjourneyClient,
        midjourneyRepository: midjourneyRepository,
        messagesRepository: messagesRepository,
      );
}

/// Immutable version of dependencies
///
/// Used to store dependencies
final class _Dependencies$Immutable implements Dependencies {
  const _Dependencies$Immutable({
    required this.sharedPreferences,
    required this.router,
    required this.database,
    required this.midjourneyClient,
    required this.midjourneyRepository,
    required this.messagesRepository,
  });

  @override
  final SharedPreferences sharedPreferences;

  @override
  final AppRouter router;

  @override
  final Midjourney midjourneyClient;

  @override
  final AppDatabase database;

  @override
  final MidjourneyRepository midjourneyRepository;

  @override
  final MessagesRepository messagesRepository;

  @override
  Dependencies freeze() => this;
}

final class InitializationResult {
  const InitializationResult({
    required this.dependencies,
    required this.stepCount,
    required this.msSpent,
  });

  final Dependencies dependencies;
  final int stepCount;
  final int msSpent;
}
