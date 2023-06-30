import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:midjourney_client_ui/src/core/utils/extensions/context_extension.dart';
import 'package:midjourney_client_ui/src/feature/settings/model/user_settings.dart';
import 'package:midjourney_client_ui/src/feature/settings/widget/settings_category.dart';
import 'package:midjourney_client_ui/src/feature/settings/widget/settings_scope.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _channelIdController;
  late final TextEditingController _serverIdController;
  late final TextEditingController _tokenController;

  @override
  void initState() {
    final settings = SettingsScope.settingsOf(context, listen: false);
    _channelIdController = TextEditingController(
      text: settings.channelId,
    );
    _serverIdController = TextEditingController(
      text: settings.serverId,
    );
    _tokenController = TextEditingController(
      text: settings.token,
    );
    super.initState();
  }

  void _save() {
    final settings = UserSettings(
      token: _tokenController.text,
      serverId: _serverIdController.text,
      channelId: _channelIdController.text,
    );
    SettingsScope.of(context).update(settings);
  }

  @override
  Widget build(BuildContext context) {
    final controller = SettingsScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.stringOf().settings),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.list(
              children: [
                SettingsCategory(
                  category: context.stringOf().discord,
                ),
                TextField(
                  controller: _tokenController,
                  cursorHeight: context.textThemeOf().bodyLarge!.fontSize,
                  decoration: InputDecoration(
                    label: Text(context.stringOf().discord_token),
                    icon: const Icon(Icons.key),
                    border: const UnderlineInputBorder(),
                    filled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: _serverIdController,
                    cursorHeight: context.textThemeOf().bodyLarge!.fontSize,
                    decoration: InputDecoration(
                      label: Text(context.stringOf().discord_server_id),
                      icon: const Icon(Icons.home),
                      border: const UnderlineInputBorder(),
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: _channelIdController,
                    cursorHeight: context.textThemeOf().bodyLarge!.fontSize,
                    decoration: InputDecoration(
                      label: Text(context.stringOf().discord_channel_id),
                      icon: const Icon(Icons.chat),
                      border: const UnderlineInputBorder(),
                      filled: true,
                    ),
                  ),
                ),
                SettingsCategory(
                  category: context.stringOf().developer,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.restore),
                  title: Text(context.stringOf().reset_db),
                  subtitle: Text(context.stringOf().reset_db_description),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(context.stringOf().reset_db),
                        content: Text(context.stringOf().reset_db_confirm),
                        actions: [
                          TextButton(
                            onPressed: context.router.pop,
                            child: Text(context.stringOf().cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              context.router.pop();
                              controller.resetDatabase();
                            },
                            child: Text(context.stringOf().reset),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
