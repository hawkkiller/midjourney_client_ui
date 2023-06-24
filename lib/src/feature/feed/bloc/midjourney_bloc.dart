import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:midjourney_client_ui/src/feature/feed/data/midjourney_repository.dart';

@immutable
sealed class MidjourneyState {
  const MidjourneyState();

  @override
  String toString() => runtimeType.toString();
}

final class MidjourneyState$Idle extends MidjourneyState {
  const MidjourneyState$Idle();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MidjourneyState$Idle;

  @override
  int get hashCode => 0;
}

final class MidjourneyState$Loading extends MidjourneyState {
  const MidjourneyState$Loading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MidjourneyState$Loading;

  @override
  int get hashCode => 0;
}

final class MidjourneyState$Error extends MidjourneyState {
  const MidjourneyState$Error(this.message);

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MidjourneyState$Error &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

final class MidjourneyState$Success extends MidjourneyState {
  const MidjourneyState$Success();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MidjourneyState$Success;

  @override
  int get hashCode => 0;
}

@immutable
sealed class MidjourneyEvent {
  const MidjourneyEvent();

  const factory MidjourneyEvent.imagine(
    String prompt,
  ) = MidjourneyEvent$Imagine;

  @override
  String toString() => runtimeType.toString();
}

final class MidjourneyEvent$Imagine extends MidjourneyEvent {
  const MidjourneyEvent$Imagine(this.prompt);

  final String prompt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MidjourneyEvent$Imagine &&
          runtimeType == other.runtimeType &&
          prompt == other.prompt;

  @override
  int get hashCode => prompt.hashCode;
}

final class MidjourneyEvent$Variations extends MidjourneyEvent {
  const MidjourneyEvent$Variations(this.image, this.index);

  final String image;
  final int index;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MidjourneyEvent$Variations &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          index == other.index;

  @override
  int get hashCode => image.hashCode ^ index.hashCode;
}

final class MidjourneyEvent$Upscale extends MidjourneyEvent {
  const MidjourneyEvent$Upscale(this.image);

  final String image;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MidjourneyEvent$Upscale &&
          runtimeType == other.runtimeType &&
          image == other.image;

  @override
  int get hashCode => image.hashCode;
}

class MidjourneyBloc extends Bloc<MidjourneyEvent, MidjourneyState> {
  MidjourneyBloc(this._repository) : super(const MidjourneyState$Idle()) {
    on<MidjourneyEvent>(
      (event, emitter) => switch (event) {
        final MidjourneyEvent$Imagine event => _imagine(event, emitter),
        final MidjourneyEvent$Variations event => _variations(event, emitter),
        final MidjourneyEvent$Upscale event => _upscale(event, emitter),
      },
    );
  }

  final MidjourneyRepository _repository;

  Future<void> _imagine(
    MidjourneyEvent$Imagine event,
    Emitter<MidjourneyState> emitter,
  ) async {
    emitter(const MidjourneyState$Loading());
    try {
      await _repository.imagine(event.prompt);
      emitter(const MidjourneyState$Success());
    } on Object catch (e) {
      emitter(MidjourneyState$Error(e.toString()));
      rethrow;
    }
  }

  Future<void> _variations(
    MidjourneyEvent$Variations event,
    Emitter<MidjourneyState> emitter,
  ) async {
    emitter(const MidjourneyState$Loading());
    try {
      await _repository.variations(event.image, event.index);
      emitter(const MidjourneyState$Success());
    } on Object catch (e) {
      emitter(MidjourneyState$Error(e.toString()));
      rethrow;
    }
  }

  Future<void> _upscale(
    MidjourneyEvent$Upscale event,
    Emitter<MidjourneyState> emitter,
  ) async {
    emitter(const MidjourneyState$Loading());
    try {
      await _repository.upscale(event.image);
      emitter(const MidjourneyState$Success());
    } on Object catch (e) {
      emitter(MidjourneyState$Error(e.toString()));
      rethrow;
    }
  }
}
