import 'package:midjourney_client_ui/src/feature/feed/data/messages_repository.dart';

class SettingsBloc {
  SettingsBloc({
    required MessagesRepository messagesRepository,
  }) : _messagesRepository = messagesRepository;

  final MessagesRepository _messagesRepository;

  Future<void> resetDb() => _messagesRepository.resetDb();
}
