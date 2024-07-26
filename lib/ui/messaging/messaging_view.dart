import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/messaging/test_channel_list_view.dart';

class MessagingChannelListView extends StatelessWidget {
  const MessagingChannelListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'messages',
        ),
      ),
      // body: ChannelListView(
      //   client: client,
      // ),
      body: const SafeArea(child: ChannelList()),
    );
  }
}
