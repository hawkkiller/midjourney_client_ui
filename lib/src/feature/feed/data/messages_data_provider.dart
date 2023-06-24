import 'dart:async';

import 'package:database/database.dart';
import 'package:drift/drift.dart';
import 'package:midjourney_client_ui/src/feature/feed/model/message_model.dart';

part 'messages_data_provider.g.dart';

abstract interface class MessagesDataProvider {
  /// Upserts a message
  Future<void> createOrUpdate(MessageModel message);

  /// List of messages
  abstract final Stream<List<MessageModel>> messages;
}

class MessagesDaoDriftImpl implements MessagesDataProvider {
  MessagesDaoDriftImpl(this.db) {
    _messagesController = StreamController<List<MessageModel>>.broadcast(
      onListen: () async {
        _messagesController.add(await _getCache());
      },
    );
  }

  final AppDatabase db;

  List<MessageModel>? _cache;

  late final StreamController<List<MessageModel>> _messagesController;

  Future<List<MessageModel>> _getCache() async {
    final models = (await db.select(db.messageTbl).get())
        .map(
          (e) => MessageModel(
            id: e.id,
            title: e.title,
            uri: e.uri,
          ),
        )
        .toList();
    _cache ??= models;
    return models;
  }

  Future<void> _addCache(MessageModel model) async {
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
  Future<void> createOrUpdate(MessageModel message) async {
    await db.into(db.messageTbl).insertOnConflictUpdate(
          MessageTblCompanion.insert(
            id: message.id,
            title: Value(message.title),
            uri: Value(message.uri),
          ),
        );
    await _addCache(message);
  }

  @override
  Stream<List<MessageModel>> get messages => _messagesController.stream;

  Future<void> close() => _messagesController.close();
}
