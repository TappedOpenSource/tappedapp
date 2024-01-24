import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/messaging/channel_list_view.dart';

class MessagingChannelListView extends StatelessWidget {
  const MessagingChannelListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Hero(
          tag: 'searchBar',
          child: SearchBar(
            hintText: 'Search...',
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            onTap: () {
              context.push(
                SearchPage(),
              );
            },
          ),
        ),
      ),
      // appBar: const TappedAppBar(
      //   trailing: NotificationIconButton(),
      // ),
      body: const ChannelListView(),
    );
  }
}
