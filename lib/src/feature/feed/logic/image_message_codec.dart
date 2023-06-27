import 'dart:convert';

import 'package:midjourney_client/midjourney_client.dart';
import 'package:midjourney_client_ui/src/feature/feed/model/message_model.dart';

class ImageMessageDecoder extends Converter<MidjourneyMessage$Image, ImageMessage> {
  const ImageMessageDecoder(this.type);

  final ImageMessageType type;

  @override
  ImageMessage convert(MidjourneyMessage$Image input) => ImageMessage(
        progress: input.progress,
        messageId: input.messageId,
        prompt: input.content,
        id: input.id,
        uri: input.uri,
        type: type,
      );
}

class ImageMessageEncoder extends Converter<ImageMessage, MidjourneyMessage$Image> {
  const ImageMessageEncoder();
  @override
  MidjourneyMessage$Image convert(ImageMessage input) {
    if (input.progress != 100) {
      return MidjourneyMessage$ImageProgress(
        progress: input.progress,
        messageId: input.messageId,
        content: input.prompt ?? '',
        id: input.id,
        uri: input.uri,
      );
    }
    return MidjourneyMessage$ImageFinish(
      messageId: input.messageId,
      content: input.prompt ?? '',
      id: input.id,
      uri: input.uri,
    );
  }
}
