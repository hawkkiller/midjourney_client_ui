import 'dart:async';

import 'package:midjourney_client/midjourney_client.dart';
import 'package:midjourney_client_ui/src/feature/feed/logic/image_message_codec.dart';
import 'package:midjourney_client_ui/src/feature/feed/model/message_model.dart';

/// Repository for midjourney.
///
/// This repository is responsible for all the midjourney related operations.
abstract interface class MidjourneyRepository {
  /// Stream of messages being imagined, upscaled, etc.
  abstract final Stream<ImageMessage> messages;

  Future<void> initialize({
    required String token,
    required String serverId,
    required String channelId,
  });

  /// Imagine a prompt.
  Future<void> imagine(String prompt);

  /// Upscale image
  Future<void> upscale(ImageMessage image, int index);

  /// Create variations
  Future<void> variation(ImageMessage image, int index);
}

final class MidjourneyRepositoryImpl implements MidjourneyRepository {
  MidjourneyRepositoryImpl({
    required Midjourney midjourneyClient,
  }) : _midjourneyClient = midjourneyClient;

  final Midjourney _midjourneyClient;

  static const _imagineDecoder = ImageMessageDecoder(ImageMessageType.imagine);
  static const _upscaleDecoder = ImageMessageDecoder(ImageMessageType.upscale);
  static const _variationDecoder = ImageMessageDecoder(ImageMessageType.variation);
  static const _encoder = ImageMessageEncoder();

  final _controller = StreamController<ImageMessage>.broadcast(sync: true);

  @override
  Future<void> initialize({
    required String token,
    required String serverId,
    required String channelId,
  }) async {
    await _midjourneyClient.initialize(
      token: token,
      serverId: serverId,
      channelId: channelId,
      baseUrl: 'https://proxy.lazebny.io/discord/',
      wsUrl: 'wss://proxy.lazebny.io/discord-ws/',
      cdnUrl: 'https://proxy.lazebny.io/discord-cdn/',
    );
  }

  @override
  Stream<ImageMessage> get messages => _controller.stream;

  @override
  Future<void> imagine(String prompt) async {
    final stream = _midjourneyClient.imagine(prompt).map(_imagineDecoder.convert);
    final first = await stream.first;

    _controller.add(first);
    StreamSubscription<Object>? subscription;

    subscription = stream.listen(
      _controller.add,
      onError: (dynamic error) {
        subscription?.cancel();
      },
      onDone: () => subscription?.cancel(),
    );
  }

  @override
  Future<void> upscale(ImageMessage image, int index) async {
    final stream = _midjourneyClient.upscale(_encoder.convert(image), index).map(
          _upscaleDecoder.convert,
        );
    StreamSubscription<Object>? subscription;
    final completer = Completer<void>();

    subscription = stream.listen(
      (e) {
        _controller.add(e);
        if (completer.isCompleted) return;
        completer.complete();
      },
      onError: (dynamic error) {
        subscription?.cancel();
        completer.completeError(error as Object);
      },
      onDone: () => subscription?.cancel(),
    );
    await completer.future;
  }

  @override
  Future<void> variation(ImageMessage image, int index) async {
    final stream =
        _midjourneyClient.variation(_encoder.convert(image), index).map(_variationDecoder.convert);
    final first = await stream.first;

    _controller.add(first);
    StreamSubscription<Object>? subscription;

    subscription = stream.listen(
      _controller.add,
      onError: (dynamic error) {
        subscription?.cancel();
      },
      onDone: () => subscription?.cancel(),
    );
  }

  Future<void> close() async {
    await _controller.close();
  }
}
