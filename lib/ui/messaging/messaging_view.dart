import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/messaging/channel_list_view.dart';
import 'package:intheloopapp/ui/profile/components/notification_icon_button.dart';

class MessagingChannelListView extends StatelessWidget {
  const MessagingChannelListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: const TappedAppBar(
        title: 'Messaging',
        trailing: NotificationIconButton(),
      ),
      body: const ChannelListView(),
    );
  }
}
