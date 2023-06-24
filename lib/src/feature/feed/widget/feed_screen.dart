import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midjourney_client_ui/src/core/router/router.dart';
import 'package:midjourney_client_ui/src/core/utils/extensions/context_extension.dart';
import 'package:midjourney_client_ui/src/feature/feed/bloc/messages_bloc.dart';
import 'package:midjourney_client_ui/src/feature/feed/bloc/midjourney_bloc.dart';
import 'package:midjourney_client_ui/src/feature/feed/model/message_model.dart';
import 'package:midjourney_client_ui/src/feature/initialization/widget/dependencies_scope.dart';

@RoutePage()
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final TextEditingController _promptController;
  late final MidjourneyBloc _midjourneyBloc;
  late final MessagesBloc _messagesBloc;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
    _messagesBloc = MessagesBloc(
      messagesRepository: DependenciesScope.of(context).messagesRepository,
      midjourneyRepository: DependenciesScope.of(context).midjourneyRepository,
    );
    _midjourneyBloc = MidjourneyBloc(
      DependenciesScope.of(context).midjourneyRepository,
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    _messagesBloc.close();
    _midjourneyBloc.close();
    super.dispose();
  }

  void _sendPrompt(String prompt) {
    if (prompt.isEmpty) {
      return;
    }
    _midjourneyBloc.add(MidjourneyEvent.imagine(prompt));
    _promptController.clear();
  }

  void _sendUpscale(ImageMessage message, int index) {
    _midjourneyBloc.add(MidjourneyEvent.upscale(message, index));
  }

  void _sendVariation(ImageMessage message, int index) {
    _midjourneyBloc.add(MidjourneyEvent.variations(message, index));
  }

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: SizedBox(
          width: shortestSide,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: context.schemeOf().shadow.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _promptController,
              onSubmitted: _sendPrompt,
              minLines: 1,
              maxLines: null,
              decoration: InputDecoration(
                filled: true,
                fillColor: context.schemeOf().surface,
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _promptController,
                  builder: (context, value, __) {
                    final prompt = value.text;
                    return IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: prompt.isEmpty
                          ? null
                          : () => _sendPrompt(_promptController.text),
                    );
                  },
                ),
                labelText: context.stringOf().send_prompt,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: .2,
                    color: context.schemeOf().outline,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(context.stringOf().appTitle),
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  context.router.push(const SettingsRoute());
                },
              ),
            ],
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 8),
          ),
          BlocBuilder<MessagesBloc, MessagesState>(
            bloc: _messagesBloc,
            builder: (context, state) {
              final messages = state.messages;
              if (messages.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(context.stringOf().no_messages),
                  ),
                );
              }
              return SliverList.builder(
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            message.prompt ?? 'Empty Title',
                            style: context.textThemeOf().labelMedium,
                          ),
                          if (message.uri != null)
                            ExtendedImage.network(
                              message.uri!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          if (message.type.canBeInteracted &&
                              message.progress == 100) ...[
                            Row(
                              children: List.generate(
                                4,
                                (index) => TextButton(
                                  onPressed: () => _sendUpscale(
                                    message,
                                    index,
                                  ),
                                  child: Text(
                                    'U${index + 1}',
                                    style: context.textThemeOf().labelMedium,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                4,
                                (index) => TextButton(
                                  onPressed: () => _sendVariation(
                                    message,
                                    index,
                                  ),
                                  child: Text(
                                    'V${index + 1}',
                                    style: context.textThemeOf().labelMedium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
                itemCount: messages.length,
              );
            },
          ),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 100),
          ),
        ],
      ),
    );
  }
}
