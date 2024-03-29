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

  // void _startCall(BuildContext context) async {
  //   final currentUser = StreamChat.of(context).currentUser;
  //   final channel = StreamChannel.of(context).channel;
  //   final stream = context.stream;

  //   final call = stream.makeVideoCall(
  //     participantIds: [],
  //   );

  //   await channel.sendMessage(
  //     Message(
  //       attachments: [
  //         Attachment(
  //           type: 'custom',
  //           authorName: currentUser?.name ?? '',
  //           uploadState: const UploadState.success(),
  //           extraData: {
  //             'callCid': call.callCid,
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(
        onImageTap: () {
          final channel = StreamChannel.of(context).channel;
          final currentUserId = StreamChat.of(context).currentUser?.id;

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

          showCupertinoModalBottomSheet<void>(
            context: context,
            builder: (context) {
              return ProfileView(
                visitedUserId: otherUserId,
                visitedUser: const None(),
              );
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
