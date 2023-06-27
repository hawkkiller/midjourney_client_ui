import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:midjourney_client/midjourney_client.dart';
import 'package:midjourney_client_ui/src/core/database/open_connection.dart';
import 'package:midjourney_client_ui/src/core/router/router.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/messages_data_provider.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/messages_repository.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/midjourney_repository.dart';
import 'package:midjourney_client_ui/src/feature/initialization/model/initialization_progress.dart';
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
    'Midjourney Client': (progress) async {
      final midjourney = Midjourney(
        serverId: progress.environmentStore.midjourneyServerId,
        channelId: progress.environmentStore.midjourneyChannelId,
        token: progress.environmentStore.midjourneyToken,
        loggerLevel: kDebugMode ? MLoggerLevel.debug : MLoggerLevel.info,
      );
      await midjourney.init();
      progress.dependencies.midjourneyClient = midjourney;
    },
    'Database': (progress) {
      final database = openConnection('midjourney_client_ui');
      progress.dependencies.database = database;
    },
    'Midjourney Repository': (progress) async {
      final midjourneyRepository = MidjourneyRepositoryImpl(
        progress.dependencies.midjourneyClient,
      );
      progress.dependencies.midjourneyRepository = midjourneyRepository;
    },
    'Messages Repository': (progress) async {
      final messagesRepository = MessagesRepositoryImpl(
        MessagesDaoDriftImpl(progress.dependencies.database),
      );
      progress.dependencies.messagesRepository = messagesRepository;
    },
  };
}
