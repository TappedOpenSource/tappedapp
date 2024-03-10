import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/discover/components/tapped_search_bar.dart';
import 'package:intheloopapp/ui/messaging/channel_list_view.dart';

class MessagingChannelListView extends StatelessWidget {
  const MessagingChannelListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: const TappedAppBar(
        title: 'messages',
      ),
      body: const ChannelListView(),
    );
  }
}
