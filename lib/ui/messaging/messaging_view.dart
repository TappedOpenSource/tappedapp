import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/messaging/channel_list_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MessagingChannelListView extends StatelessWidget {
  const MessagingChannelListView({super.key});

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: const TappedAppBar(
        title: 'messages',
      ),
      body: ChannelListView(
        client: client,
      ),
    );
  }
}
