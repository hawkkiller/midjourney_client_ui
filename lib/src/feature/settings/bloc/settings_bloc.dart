import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:midjourney_client_ui/src/feature/settings/data/settings_repository.dart';
import 'package:midjourney_client_ui/src/feature/settings/model/user_settings.dart';

@immutable
sealed class SettingsState {
  const SettingsState(this.settings);

  final UserSettings settings;
}

class SettingsState$Idle extends SettingsState {
  const SettingsState$Idle(super.settings);

  @override
  String toString() => 'SettingsState\$Initial $settings';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsState$Idle && other.settings == settings;
  }

  @override
  int get hashCode => settings.hashCode;
}

class SettingsState$Loading extends SettingsState {
  const SettingsState$Loading(super.settings);

  @override
  String toString() => 'SettingsState\$Loading $settings';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsState$Loading && other.settings == settings;
  }

  @override
  int get hashCode => settings.hashCode;
}

class SettingsState$Error extends SettingsState {
  const SettingsState$Error(super.settings, this.error);

  final Object error;

  @override
  String toString() => 'SettingsState\$Error $settings $error';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsState$Error && other.settings == settings && other.error == error;
  }

  @override
  int get hashCode => settings.hashCode ^ error.hashCode;
}

sealed class SettingsEvent {
  const SettingsEvent();

  factory SettingsEvent.load() => const _SettingsEvent$Load();

  factory SettingsEvent.update(UserSettings settings) => _SettingsEvent$Update(settings);
}

class _SettingsEvent$Load extends SettingsEvent {
  const _SettingsEvent$Load();
}

class _SettingsEvent$Update extends SettingsEvent {
  const _SettingsEvent$Update(this.settings);

  final UserSettings settings;
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._repository) : super(SettingsState$Idle(_repository.read())) {
    on<SettingsEvent>(
      (event, emit) => switch (event) {
        _SettingsEvent$Load() => _load(event, emit),
        _SettingsEvent$Update() => _update(event, emit)
      },
    );
  }

  final SettingsRepository _repository;

  Future<void> _load(
    _SettingsEvent$Load event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsState$Loading(state.settings));
    try {
      final settings = _repository.read();
      emit(SettingsState$Idle(settings));
    } on Object catch (error) {
      emit(SettingsState$Error(state.settings, error));
      rethrow;
    }
  }

  Future<void> _update(
    _SettingsEvent$Update event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsState$Loading(state.settings));
    try {
      await _repository.write(event.settings);
      emit(SettingsState$Idle(event.settings));
    } on Object catch (error) {
      emit(SettingsState$Error(state.settings, error));
      rethrow;
    }
  }
}
