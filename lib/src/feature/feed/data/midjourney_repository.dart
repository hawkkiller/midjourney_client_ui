import 'dart:async';

import 'package:midjourney_client/midjourney_client.dart';
import 'package:midjourney_client_ui/src/feature/feed/model/message_model.dart';

/// Repository for midjourney.
/// 
/// This repository is responsible for all the midjourney related operations.
abstract interface class MidjourneyRepository {
  /// Stream of messages being imagined, upscaled, etc.
  abstract final Stream<MessageModel> messages;

  /// Imagine a prompt.
  Future<void> imagine(String prompt);

  /// Upscale image
  Future<void> upscale(String image);

  /// Create variations
  Future<void> variations(String image, int index);
}

final class MidjourneyRepositoryImpl implements MidjourneyRepository {
  MidjourneyRepositoryImpl(this._client);

  final Midjourney _client;

  final _controller = StreamController<MessageModel>.broadcast(sync: true);

  @override
  Stream<MessageModel> get messages => _controller.stream;

  @override
  Future<void> imagine(String prompt) async {
    final stream = _client.imagine(prompt).map(
          (event) => MessageModel(
            id: event.id,
            title: event.content,
            uri: event.uri,
          ),
        );
    final first = await stream.first;

    _controller.add(first);
    StreamSubscription<Object>? subscription;

    subscription = stream.listen(
      _controller.add,
      onError: (dynamic error) {
        // TODO(mlazebny): Think what to do onError.
        subscription?.cancel();
      },
      onDone: () => subscription?.cancel(),
    );
  }

  @override
  Future<void> upscale(String image) async {
    // final stream = _client.upscale();
  }

  @override
  Future<void> variations(String image, int index) async {
    // await _client.variations(image, index);
  }

  Future<void> close() async {
    await _controller.close();
  }
}
