import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midjourney_client_ui/src/core/utils/extensions/context_extension.dart';
import 'package:midjourney_client_ui/src/core/utils/mixin/scope_mixin.dart';
import 'package:midjourney_client_ui/src/feature/feed/bloc/midjourney_connection_bloc.dart';
import 'package:midjourney_client_ui/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:midjourney_client_ui/src/feature/settings/bloc/database_bloc.dart';
import 'package:midjourney_client_ui/src/feature/settings/bloc/settings_bloc.dart';
import 'package:midjourney_client_ui/src/feature/settings/model/user_settings.dart';

abstract interface class SettingsController {
  /// Resets the database.
  void resetDatabase();

  /// Update the [UserSettings].
  void update(UserSettings settings);
}

class SettingsScope extends StatefulWidget {
  const SettingsScope({
    required this.child,
    super.key,
  });

  final Widget child;

  /// Returns the current [UserSettings].
  static UserSettings settingsOf(
    BuildContext context, {
    bool listen = true,
  }) =>
      ScopeMixin.scopeOf<_InheritedSettings>(context, listen: listen).state.settings;

  /// Returns the closest [SettingsController] which encloses the given context.
  static SettingsController of(
    BuildContext context, {
    bool listen = true,
  }) =>
      ScopeMixin.scopeOf<_InheritedSettings>(context, listen: listen).controller;

  @override
  State<SettingsScope> createState() => _SettingsScopeState();
}

class _SettingsScopeState extends State<SettingsScope> implements SettingsController {
  late final SettingsBloc _settingsBloc;
  late final DatabaseBloc _databaseBloc;

  @override
  void initState() {
    super.initState();
    _settingsBloc = SettingsBloc(
      DependenciesScope.of(context).settingsRepository,
    );
    _databaseBloc = DatabaseBloc(
      DependenciesScope.of(context).messagesRepository,
    );
    _initMidjourney(_settingsBloc.state.settings);
  }

  @override
  void dispose() {
    _settingsBloc.close();
    _databaseBloc.close();
    super.dispose();
  }

  @override
  void resetDatabase() => _databaseBloc.add(DatabaseEvent.reset());

  void _showSnackbar(String text, [String? e]) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$text${e != null ? '/n$e' : ''}'),
          duration: const Duration(seconds: 2),
        ),
      );

  void _initMidjourney(UserSettings settings) {
    if (settings.channelId.isEmpty || settings.serverId.isEmpty || settings.token.isEmpty) return;
    context.read<MidjourneyConnectionBloc>().add(
          MidjourneyConnectionEvent.connect(
            token: settings.token,
            serverId: settings.serverId,
            channelId: settings.channelId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) => BlocListener<DatabaseBloc, DatabaseState>(
        bloc: _databaseBloc,
        listener: (context, state) {
          if (state.isSuccess) {
            _showSnackbar(context.stringOf().reset_db_success);
          }
          if (state.isError) {
            _showSnackbar(
              context.stringOf().reset_db_error,
              state.errorValue?.toString(),
            );
          }
        },
        child: BlocConsumer<SettingsBloc, SettingsState>(
          bloc: _settingsBloc,
          listenWhen: (previous, current) =>
              previous.settings.serverId != current.settings.serverId ||
              previous.settings.channelId != current.settings.channelId ||
              previous.settings.token != current.settings.token,
          listener: (context, state) {
            _initMidjourney(state.settings);
          },
          builder: (context, state) => _InheritedSettings(
            state: state,
            controller: this,
            child: widget.child,
          ),
        ),
      );

  @override
  void update(UserSettings settings) => _settingsBloc.add(SettingsEvent.update(settings));
}

class _InheritedSettings extends InheritedWidget {
  const _InheritedSettings({
    required this.state,
    required this.controller,
    required super.child,
  });

  final SettingsState state;
  final SettingsController controller;

  @override
  bool updateShouldNotify(_InheritedSettings oldWidget) => false;
}
