import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/messaging/channel_header.dart';
import 'package:intheloopapp/ui/profile/profile_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
          final currentUserId = StreamChat.of(context).currentUser?.id;

          showChannelInfoModalBottomSheet<void>(
            context: context,
            channel: channel,
            onMemberTap: (member) {
              final userId = member.user?.id;
              if (userId == null) {
                Navigator.pop(context);
                return;
              }

              showCupertinoModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return ProfileView(
                    visitedUserId: userId,
                    visitedUser: const None(),
                  );
                },
              );
            },
            onViewInfoTap: () {
              if (currentUserId == null) {
                Navigator.pop(context);
                return;
              }

              final memberCount = channel.memberCount ?? 0;
              if (memberCount > 2) {
                Navigator.pop(context);
                return;
              }

              final otherMember = channel.state?.members
                  .where((member) => member.userId != currentUserId)
                  .first;

              final otherUserId = otherMember?.userId;
              if (otherUserId == null) {
                Navigator.pop(context);
                return;
              }

              showCupertinoModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return ProfileView(
                    visitedUserId: otherUserId,
                    visitedUser: const None(),
                  );
                },
              );
              // Navigate to info screen
            },
          );
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamMessageListView(
              messageBuilder: (
                context,
                message,
                listIndex,
                streamMessageWidget,
              ) {
                return streamMessageWidget.copyWith(
                  onUserAvatarTap: (user) {
                    showCupertinoModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return ProfileView(
                          visitedUserId: user.id,
                          visitedUser: const None(),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const StreamMessageInput(),
        ],
      ),
    );
  }
}
