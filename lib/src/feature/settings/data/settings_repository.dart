import 'dart:async';

import 'package:midjourney_client_ui/src/feature/settings/data/settings_data_provider.dart';
import 'package:midjourney_client_ui/src/feature/settings/model/user_settings.dart';

abstract interface class SettingsRepository {
  /// Read user settings
  UserSettings read();

  /// Write user settings
  Future<void> write(UserSettings data);
}

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._dataProvider);

  final SettingsDataProvider _dataProvider;

  @override
  UserSettings read() => _dataProvider.read();

  @override
  Future<void> write(UserSettings data) => _dataProvider.write(data);
}
