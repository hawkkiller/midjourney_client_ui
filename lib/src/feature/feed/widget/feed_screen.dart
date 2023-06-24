import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midjourney_client_ui/src/core/utils/extensions/context_extension.dart';
import 'package:midjourney_client_ui/src/feature/feed/bloc/messages_bloc.dart';
import 'package:midjourney_client_ui/src/feature/feed/bloc/midjourney_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SizedBox(
          width: shortestSide,
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
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
                onPressed: () {},
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
                  return ListTile(
                    leading: CircleAvatar(
                      child: message.uri != null
                          ? Image.network(message.uri!)
                          : null,
                    ),
                    title: Text(message.title ?? 'Empty Title'),
                    subtitle: Text(message.id),
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
