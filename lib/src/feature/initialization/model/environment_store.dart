import 'package:midjourney_client_ui/src/feature/initialization/model/enum/environment.dart';

abstract class EnvironmentStore {
  /// Environment - dev, prod
  abstract final Environment environment;

  /// Sentry DSN
  abstract final String sentryDsn;

  /// Midjourney token
  abstract final String? midjourneyToken;

  /// Midjourney channel ID
  abstract final String? midjourneyChannelId;

  /// Midjourney server ID
  abstract final String? midjourneyServerId;

  /// Whether the environment is production
  bool get isProduction => environment == Environment.prod;
}

class EnvironmentStore$Impl extends EnvironmentStore {
  EnvironmentStore$Impl();

  static final _env = Environment.fromEnvironment(
    const String.fromEnvironment('ENV'),
  );

  @override
  Environment get environment => _env;

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');

  @override
  String? get midjourneyToken => const bool.hasEnvironment('MIDJOURNEY_TOKEN')
      ? const String.fromEnvironment('MIDJOURNEY_TOKEN')
      : null;

  @override
  String? get midjourneyChannelId => const bool.hasEnvironment('MIDJOURNEY_CHANNEL_ID')
      ? const String.fromEnvironment('MIDJOURNEY_CHANNEL_ID')
      : null;

  @override
  String? get midjourneyServerId => const bool.hasEnvironment('MIDJOURNEY_SERVER_ID')
      ? const String.fromEnvironment('MIDJOURNEY_SERVER_ID')
      : null;
}
