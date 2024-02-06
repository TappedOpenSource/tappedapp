import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/discover/components/tapped_search_bar.dart';
import 'package:intheloopapp/ui/messaging/channel_list_view.dart';

class MessagingChannelListView extends StatelessWidget {
  const MessagingChannelListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const TappedSearchBar(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: const ChannelListView(),
    );
  }
}
