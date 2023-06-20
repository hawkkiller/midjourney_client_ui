import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:midjourney_client_ui/src/core/utils/extensions/context_extension.dart';

/// {@template sample_page}
/// SamplePage widget
/// {@endtemplate}
@RoutePage()
class SampleScreen extends StatelessWidget {
  /// {@macro sample_page}
  const SampleScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.stringOf().appTitle),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Text(
              context.stringOf().samplePlaceholder('Misha'),
            ),
          ],
        ),
      );
}
