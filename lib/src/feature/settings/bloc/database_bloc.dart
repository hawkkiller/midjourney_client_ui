import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/messages_repository.dart';

@immutable
sealed class DatabaseState {
  const DatabaseState();

  bool get isSuccess => switch (this) {
        DatabaseState$Success() => true,
        _ => false,
      };

  bool get isError => switch (this) {
        DatabaseState$Error() => true,
        _ => false,
      };
  
  Object? get errorValue => switch (this) {
        final DatabaseState$Error e => e.error,
        _ => null,
      };
}

final class DatabaseState$Idle extends DatabaseState {
  const DatabaseState$Idle();

  @override
  String toString() => r'DatabaseState$Idle';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DatabaseState$Idle;
  }

  @override
  int get hashCode => 0;
}

final class DatabaseState$Progress extends DatabaseState {
  const DatabaseState$Progress();

  @override
  String toString() => r'DatabaseState$Loading';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DatabaseState$Progress;
  }

  @override
  int get hashCode => 0;
}

final class DatabaseState$Success extends DatabaseState {
  const DatabaseState$Success();

  @override
  String toString() => r'DatabaseState$Success';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DatabaseState$Success;
  }

  @override
  int get hashCode => 0;
}

final class DatabaseState$Error extends DatabaseState {
  const DatabaseState$Error(this.error);

  final Object error;

  @override
  String toString() => 'DatabaseState\$Error $error';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DatabaseState$Error && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

@immutable
sealed class DatabaseEvent {
  const DatabaseEvent();

  factory DatabaseEvent.reset() => const _DatabaseEvent$Reset();
}

final class _DatabaseEvent$Reset extends DatabaseEvent {
  const _DatabaseEvent$Reset();

  @override
  String toString() => r'DatabaseEvent$Reset';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _DatabaseEvent$Reset;
  }

  @override
  int get hashCode => 0;
}

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc(this._messagesRepository) : super(const DatabaseState$Idle()) {
    on<DatabaseEvent>(
      (event, emit) => switch (event) {
        _DatabaseEvent$Reset() => _reset(event, emit),
      },
    );
  }

  final MessagesRepository _messagesRepository;

  Future<void> _reset(
    _DatabaseEvent$Reset event,
    Emitter<DatabaseState> emit,
  ) async {
    emit(const DatabaseState$Progress());
    try {
      await _messagesRepository.resetData();
      emit(const DatabaseState$Success());
    } on Object catch (error) {
      emit(DatabaseState$Error(error));
      rethrow;
    }
  }
}
