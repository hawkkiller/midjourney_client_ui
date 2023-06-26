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
  late final MidjourneyBloc _midjourneyBloc;
  late final MessagesBloc _messagesBloc;

  @override
  void initState() {
    super.initState();
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
    _messagesBloc.close();
    _midjourneyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return BlocProvider.value(
      value: _midjourneyBloc,
      child: LayoutBuilder(
        builder: (context, constraints) => Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: const _PromptField(),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(context.stringOf().appTitle),
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => context.router.push(const SettingsRoute()),
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
                  return SliverPadding(
                    padding: switch (constraints.biggest.shortestSide) {
                      > 600 => EdgeInsets.symmetric(
                          horizontal: (width - width / 1.5) / 2,
                        ),
                      _ => const EdgeInsets.symmetric(horizontal: 16),
                    },
                    sliver: SliverList.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _MessageItem(message);
                      },
                      itemCount: messages.length,
                    ),
                  );
                },
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromptField extends StatefulWidget {
  const _PromptField();

  @override
  State<_PromptField> createState() => __PromptFieldState();
}

class __PromptFieldState extends State<_PromptField> {
  late final TextEditingController _promptController;

  void _sendPrompt(String prompt) {
    if (prompt.isEmpty) {
      return;
    }
    context.read<MidjourneyBloc>().add(MidjourneyEvent.imagine(prompt));
    _promptController.clear();
  }

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Container(
          color: context.schemeOf().surface,
          width: double.infinity,
          padding: switch (constraints.biggest.shortestSide) {
            > 600 => const EdgeInsets.fromLTRB(32, 0, 32, 16),
            _ => const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: context.schemeOf().shadow.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _promptController,
              onSubmitted: _sendPrompt,
              decoration: InputDecoration(
                filled: true,
                fillColor: context.schemeOf().surface,
                hintText: context.stringOf().send_prompt,
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
              ),
            ),
          ),
        ),
      );
}

class _MessageItem extends StatefulWidget {
  const _MessageItem(this.message);

  final ImageMessage message;

  @override
  State<_MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<_MessageItem> {
  void _sendUpscale(ImageMessage message, int index) {
    context.read<MidjourneyBloc>().add(
          MidjourneyEvent.upscale(message, index),
        );
  }

  void _sendVariation(ImageMessage message, int index) {
    context.read<MidjourneyBloc>().add(
          MidjourneyEvent.variations(message, index),
        );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: switch (constraints.biggest.shortestSide) {
            > 600 => const EdgeInsets.symmetric(horizontal: 32),
            _ => EdgeInsets.zero,
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                widget.message.prompt ?? 'Empty Title',
                style: context.textThemeOf().labelMedium,
              ),
              if (widget.message.uri != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ExtendedImage.network(
                      widget.message.uri!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (widget.message.type.canBeInteracted &&
                  widget.message.progress == 100) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: List.generate(
                      4,
                      (index) => TextButton(
                        onPressed: () => _sendUpscale(
                          widget.message,
                          index + 1,
                        ),
                        child: Text(
                          'U${index + 1}',
                          style: context.textThemeOf().labelMedium,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(
                    4,
                    (index) => TextButton(
                      onPressed: () => _sendVariation(
                        widget.message,
                        index + 1,
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
}
