import 'package:midjourney_client_ui/src/feature/feed/data/messages_data_provider.dart';
import 'package:midjourney_client_ui/src/feature/feed/model/message_model.dart';

/// Repository for messages
abstract interface class MessagesRepository {
  /// Upserts a message
  Future<void> createOrUpdate(ImageMessage message);

  /// Resets the database
  Future<void> resetDb();

  /// List of messages
  abstract final Stream<List<ImageMessage>> messages;
}

final class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl(this._messagesDataProvider);

  final MessagesDataProvider _messagesDataProvider;

  @override
  Future<void> resetDb() => _messagesDataProvider.resetDb();

  @override
  Future<void> createOrUpdate(ImageMessage message) =>
      _messagesDataProvider.createOrUpdate(message);

  @override
  Stream<List<ImageMessage>> get messages => _messagesDataProvider.messages;
}
