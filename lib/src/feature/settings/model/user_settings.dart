import 'package:meta/meta.dart';

@immutable
final class UserSettings {
  const UserSettings({
    required this.token,
    required this.serverId,
    required this.channelId,
  });

  /// Discord token
  final String token;

  /// Discord server id
  final String serverId;

  /// Discord channel id
  final String channelId;

  @override
  String toString() => 'UserSettings(token: $token, serverId: $serverId, channelId: $channelId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserSettings &&
        other.token == token &&
        other.serverId == serverId &&
        other.channelId == channelId;
  }

  @override
  int get hashCode => token.hashCode ^ serverId.hashCode ^ channelId.hashCode;
}
