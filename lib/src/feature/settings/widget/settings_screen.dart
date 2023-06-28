import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:midjourney_client_ui/src/core/utils/extensions/context_extension.dart';
import 'package:midjourney_client_ui/src/feature/settings/widget/settings_category.dart';
import 'package:midjourney_client_ui/src/feature/settings/widget/settings_scope.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.stringOf().settings),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                SettingsCategory(
                  category: context.stringOf().discord,
                ),
                ListTile(
                  leading: const Icon(Icons.token),
                  title: Text(context.stringOf().discord_token),
                ),
                ListTile(
                  leading: const Icon(Icons.keyboard),
                  title: Text(context.stringOf().discord_channel_id),
                ),
                ListTile(
                  leading: const Icon(Icons.discord),
                  title: Text(context.stringOf().discord_server_id),
                ),
                SettingsCategory(
                  category: context.stringOf().developer,
                ),
                ListTile(
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
                              SettingsScope.of(context).resetDb().ignore();
                              context.router.pop();
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
          ],
        ),
      );
}
