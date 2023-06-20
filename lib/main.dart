import 'package:midjourney_client_ui/runner_unsupported.dart'
    if (dart.library.html) 'runner_web.dart'
    if (dart.library.io) 'runner_io.dart' as runner;

Future<void> main() async => runner.run();
