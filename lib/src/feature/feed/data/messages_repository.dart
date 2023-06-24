import 'package:midjourney_client_ui/src/feature/feed/data/messages_data_provider.dart';
import 'package:midjourney_client_ui/src/feature/feed/model/message_model.dart';

/// Repository for messages
abstract interface class MessagesRepository {
  /// Upserts a message
  Future<void> createOrUpdate(MessageModel message);

  /// List of messages
  abstract final Stream<List<MessageModel>> messages;
}

final class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl(this._messagesDataProvider);

  final MessagesDataProvider _messagesDataProvider;

  @override
  Future<void> createOrUpdate(MessageModel message) => _messagesDataProvider.createOrUpdate(message);

  @override
  Stream<List<MessageModel>> get messages => _messagesDataProvider.messages;
}
