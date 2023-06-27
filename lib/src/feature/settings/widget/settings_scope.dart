import 'package:flutter/material.dart';
import 'package:midjourney_client_ui/src/core/utils/mixin/scope_mixin.dart';
import 'package:midjourney_client_ui/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:midjourney_client_ui/src/feature/settings/bloc/settings_bloc.dart';

abstract interface class SettingsController {
  Future<void> resetDb();
}

class SettingsScope extends StatefulWidget with ScopeMixin {
  const SettingsScope({
    required this.child,
    super.key,
  });

  @override
  final Widget child;

  static SettingsController of(BuildContext context) =>
      ScopeMixin.scopeOf<_InheritedSettings>(context, listen: false).controller;

  @override
  State<SettingsScope> createState() => _SettingsScopeState();
}

class _SettingsScopeState extends State<SettingsScope> implements SettingsController {
  late final SettingsBloc _settingsBloc;

  @override
  void initState() {
    _settingsBloc = SettingsBloc(
      messagesRepository: DependenciesScope.of(context).messagesRepository,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _InheritedSettings(
        controller: this,
        child: widget.child,
      );

  @override
  Future<void> resetDb() => _settingsBloc.resetDb();
}

/// {@template settings_scope}
/// _InheritedSettings widget
/// {@endtemplate}
class _InheritedSettings extends InheritedWidget {
  /// {@macro settings_scope}
  const _InheritedSettings({
    required super.child,
    required this.controller,
  });

  final SettingsController controller;

  @override
  bool updateShouldNotify(_InheritedSettings oldWidget) => false;
}
