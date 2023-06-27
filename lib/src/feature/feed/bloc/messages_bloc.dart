import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/messages_repository.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/midjourney_repository.dart';
import 'package:midjourney_client_ui/src/feature/feed/model/message_model.dart';

@immutable
sealed class MessagesState {
  const MessagesState();

  @override
  String toString() => runtimeType.toString();

  abstract final List<ImageMessage> messages;
}

final class MessagesState$Idle extends MessagesState {
  const MessagesState$Idle();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessagesState$Idle &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(messages, other.messages);

  @override
  int get hashCode => 0;

  @override
  List<ImageMessage> get messages => const [];
}

final class MessagesState$Loaded extends MessagesState {
  const MessagesState$Loaded(this.messages);

  @override
  final List<ImageMessage> messages;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessagesState$Loaded &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(messages, other.messages);

  @override
  int get hashCode => Object.hashAll(messages);
}

class MessagesBloc extends Cubit<MessagesState> {
  MessagesBloc({
    required MessagesRepository messagesRepository,
    required MidjourneyRepository midjourneyRepository,
  })  : _messagesRepository = messagesRepository,
        _midjourneyRepository = midjourneyRepository,
        super(const MessagesState$Idle()) {
    _messagesRepository.messages.listen((messages) {
      emit(MessagesState$Loaded(List.of(messages)));
    });

    _midjourneyRepository.messages.listen(_messagesRepository.createOrUpdate);
  }

  final MessagesRepository _messagesRepository;
  final MidjourneyRepository _midjourneyRepository;
}
