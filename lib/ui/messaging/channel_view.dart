import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/messaging/channel_header.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelView extends StatelessWidget {
  const ChannelView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(
        onImageTap: () {
          final channel = StreamChannel.of(context).channel;
          final currentUserId =
              StreamChat.of(context).client.state.currentUser?.id;

          if (currentUserId == null) {
            return;
          }

          final memberCount = channel.memberCount ?? 0;
          if (memberCount > 2) {
            return;
          }

          final otherMember = channel.state?.members
              .where((member) => member.userId != currentUserId)
              .first;

          final otherUserId = otherMember?.userId;
          if (otherUserId == null) {
            return;
          }

          context.push(
            ProfilePage(userId: otherUserId, user: const None()),
          );
        },
      ),
      body: const Column(
        children: [
          Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}
