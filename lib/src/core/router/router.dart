import 'package:auto_route/auto_route.dart';
import 'package:midjourney_client_ui/src/feature/feed/widget/feed_screen.dart';
import 'package:midjourney_client_ui/src/feature/settings/widget/settings_screen.dart';

part 'router.gr.dart';

/// The configuration of app routes.
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: FeedRoute.page,
          initial: true,
          path: '/',
        ),
        AutoRoute(
          page: SettingsRoute.page,
          path: '/settings',
        )
      ];
}
