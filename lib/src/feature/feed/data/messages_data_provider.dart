import 'dart:async';

import 'package:database/database.dart';
import 'package:drift/drift.dart';
import 'package:midjourney_client_ui/src/feature/feed/model/message_model.dart';

abstract interface class MessagesDataProvider {
  /// Upserts a message
  Future<void> createOrUpdate(ImageMessage message);

  /// List of messages
  abstract final Stream<List<ImageMessage>> messages;

  /// Resets the database
  Future<void> resetDb();
}

class MessagesDaoDriftImpl implements MessagesDataProvider {
  MessagesDaoDriftImpl(this.db) {
    _messagesController = StreamController<List<ImageMessage>>.broadcast(
      onListen: () async {
        _messagesController.add(await _getCache());
      },
    );
  }

  final AppDatabase db;

  List<ImageMessage>? _cache;

  late final StreamController<List<ImageMessage>> _messagesController;

  Future<List<ImageMessage>> _getCache() async {
    final models = (await db.select(db.messageTbl).get())
        .map(
          (e) => ImageMessage(
            id: e.id,
            messageId: e.messageId,
            progress: e.progress,
            prompt: e.title,
            uri: e.uri,
            type: ImageMessageType.fromString(e.messageType),
          ),
        )
        .toList();
    _cache ??= models;
    return models;
  }

  Future<void> _addCache(ImageMessage model) async {
    _cache ??= await _getCache();
    final index = _cache?.indexWhere((element) => element.id == model.id);
    if (index != null && index >= 0) {
      _cache?[index] = model;
    } else {
      _cache?.add(model);
    }
    _messagesController.add(_cache!);
  }

  @override
  Future<void> resetDb() async {
    await db.delete(db.messageTbl).go();
    _cache = null;
    _messagesController.add([]);
  }

  @override
  Future<void> createOrUpdate(ImageMessage message) async {
    await db.into(db.messageTbl).insertOnConflictUpdate(
          MessageTblCompanion.insert(
            id: message.id,
            messageId: message.messageId,
            progress: Value(message.progress),
            messageType: message.type.value,
            title: Value(message.prompt),
            uri: Value(message.uri),
          ),
        );
    await _addCache(message);
  }

  @override
  Stream<List<ImageMessage>> get messages => _messagesController.stream;

  Future<void> close() => _messagesController.close();
}
