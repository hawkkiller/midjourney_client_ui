import 'dart:async';

import 'package:midjourney_client/midjourney_client.dart';
import 'package:midjourney_client_ui/src/core/database/open_connection.dart';
import 'package:midjourney_client_ui/src/core/router/router.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/messages_data_provider.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/messages_repository.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/midjourney_repository.dart';
import 'package:midjourney_client_ui/src/feature/initialization/model/initialization_progress.dart';
import 'package:midjourney_client_ui/src/feature/settings/data/settings_data_provider.dart';
import 'package:midjourney_client_ui/src/feature/settings/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef StepAction = FutureOr<void>? Function(InitializationProgress progress);

mixin InitializationSteps {
  final initializationSteps = <String, StepAction>{
    'Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      progress.dependencies.sharedPreferences = sharedPreferences;
    },
    'App Router': (progress) {
      final router = AppRouter();
      progress.dependencies.router = router;
    },
    'Database': (progress) async {
      final database = await openConnection('midjourney_client_ui');
      progress.dependencies.database = database;
    },
    'Midjourney Repository': (progress) async {
      final midjourneyRepository = MidjourneyRepositoryImpl(
        midjourneyClient: Midjourney.instance,
      );
      progress.dependencies.midjourneyRepository = midjourneyRepository;
    },
    'Messages Repository': (progress) async {
      final messagesRepository = MessagesRepositoryImpl(
        MessagesDaoDriftImpl(progress.dependencies.database),
      );
      progress.dependencies.messagesRepository = messagesRepository;
    },
    'Settings Repository': (progress) {
      final settingsRepository = SettingsRepositoryImpl(
        SettingsDataProvider$SharedPrefs(
          progress.dependencies.sharedPreferences,
          progress.environmentStore,
        ),
      );
      progress.dependencies.settingsRepository = settingsRepository;
    }
  };
}
