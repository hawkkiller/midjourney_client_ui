import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/midjourney_repository.dart';

@immutable
sealed class MidjourneyConnectionState {
  const MidjourneyConnectionState();
}

final class MidjourneyConnectionState$Idle extends MidjourneyConnectionState {
  const MidjourneyConnectionState$Idle();

  @override
  String toString() => r'MidjourneyConnectionState$Idle';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MidjourneyConnectionState$Idle;
  }

  @override
  int get hashCode => 0;
}

final class MidjourneyConnectionState$Progress extends MidjourneyConnectionState {
  const MidjourneyConnectionState$Progress();

  @override
  String toString() => r'MidjourneyConnectionState$Loading';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MidjourneyConnectionState$Progress;
  }

  @override
  int get hashCode => 0;
}

final class MidjourneyConnectionState$Success extends MidjourneyConnectionState {
  const MidjourneyConnectionState$Success();

  @override
  String toString() => r'MidjourneyConnectionState$Success';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MidjourneyConnectionState$Success;
  }

  @override
  int get hashCode => 0;
}

final class MidjourneyConnectionState$Error extends MidjourneyConnectionState {
  const MidjourneyConnectionState$Error(this.error);

  final Object error;

  @override
  String toString() => 'MidjourneyConnectionState\$Error $error';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MidjourneyConnectionState$Error && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

@immutable
sealed class MidjourneyConnectionEvent {
  const MidjourneyConnectionEvent();

  const factory MidjourneyConnectionEvent.connect({
    required String token,
    required String serverId,
    required String channelId,
  }) = _MidjourneyConnectionEvent$Connect;
}

final class _MidjourneyConnectionEvent$Connect extends MidjourneyConnectionEvent {
  const _MidjourneyConnectionEvent$Connect({
    required this.token,
    required this.serverId,
    required this.channelId,
  });

  final String token;
  final String serverId;
  final String channelId;

  @override
  String toString() =>
      'MidjourneyConnectionEvent\$Connect(token: $token, serverId: $serverId, channelId: $channelId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _MidjourneyConnectionEvent$Connect &&
        other.token == token &&
        other.serverId == serverId &&
        other.channelId == channelId;
  }

  @override
  int get hashCode => token.hashCode ^ serverId.hashCode ^ channelId.hashCode;
}

class MidjourneyConnectionBloc extends Bloc<MidjourneyConnectionEvent, MidjourneyConnectionState> {
  MidjourneyConnectionBloc(this._midjourneyRepository)
      : super(const MidjourneyConnectionState$Idle()) {
    on<MidjourneyConnectionEvent>(
      (event, emit) => switch (event) {
        _MidjourneyConnectionEvent$Connect() => _connect(event, emit),
      },
    );
  }

  final MidjourneyRepository _midjourneyRepository;

  Future<void> _connect(
    _MidjourneyConnectionEvent$Connect event,
    Emitter<MidjourneyConnectionState> emit,
  ) async {
    emit(const MidjourneyConnectionState$Progress());
    try {
      await _midjourneyRepository.initialize(
        token: event.token,
        serverId: event.serverId,
        channelId: event.channelId,
      );
      emit(const MidjourneyConnectionState$Success());
    } on Object catch (error) {
      emit(MidjourneyConnectionState$Error(error));
      rethrow;
    }
  }
}
