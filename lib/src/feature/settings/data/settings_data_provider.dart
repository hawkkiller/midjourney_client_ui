import 'dart:async';

import 'package:midjourney_client_ui/src/feature/initialization/model/environment_store.dart';
import 'package:midjourney_client_ui/src/feature/settings/model/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SettingsDataProvider {
  /// Read settings data
  UserSettings read();

  /// Write settings data
  Future<void> write(UserSettings data);
}

final class SettingsDataProvider$SharedPrefs implements SettingsDataProvider {
  const SettingsDataProvider$SharedPrefs(this._storage, this._env);

  final SharedPreferences _storage;
  final EnvironmentStore _env;

  static const _$prefix = 'settings';

  @override
  UserSettings read() {
    final token = _storage.getString('${_$prefix}_token');
    final serverId = _storage.getString('${_$prefix}_serverId');
    final channelId = _storage.getString('${_$prefix}_channelId');

    return UserSettings(
      token: token ?? _env.midjourneyToken ?? '',
      serverId: serverId ?? _env.midjourneyServerId ?? '',
      channelId: channelId ?? _env.midjourneyChannelId ?? '',
    );
  }

  @override
  Future<void> write(UserSettings data) async {
    await _storage.setString('${_$prefix}_token', data.token);
    await _storage.setString('${_$prefix}_serverId', data.serverId);
    await _storage.setString('${_$prefix}_channelId', data.channelId);
  }
}
