import 'package:badges/badges.dart' as badges;
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/loop_feed_list_bloc/loop_feed_list_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/error/error_view.dart';
import 'package:intheloopapp/ui/views/loop_feed/loop_feed_view.dart';
import 'package:intheloopapp/ui/views/messaging/messaging_view.dart';
import 'package:intheloopapp/ui/widgets/profile_view/notification_icon_button.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class LoopFeedsListView extends StatelessWidget {
  const LoopFeedsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LoopFeedListBloc, LoopFeedListState>(
      builder: (context, state) {
        final feedParams = state.feedParamsList[state.feed];
        if (feedParams == null) return const ErrorView();
        return LoopFeedView(
          sourceFunction: feedParams.sourceFunction,
          sourceStream: feedParams.sourceStream,
          feedKey: EnumToString.convertToString(state.feed),
          scrollController: feedParams.scrollController,
          floatingActionButton: FloatingActionButton(
            heroTag: 'pushCreateLoopButton',
            child: const Icon(Icons.edit_outlined),
            onPressed: () => context.read<NavigationBloc>().add(
                  const PushCreateLoop(),
                ),
          ),
          headerSliver: SliverAppBar(
            floating: true,
            actions: [
              const NotificationIconButton(),
              StreamBuilder<int?>(
                stream: StreamChat.of(context)
                    .client
                    .on()
                    .where((event) => event.unreadChannels != null)
                    .map(
                      (event) => event.unreadChannels,
                    ),
                builder: (context, snapshot) {
                  final unreadMessagesCount = snapshot.data ?? 0;

                  return badges.Badge(
                    showBadge: unreadMessagesCount > 0,
                    position: badges.BadgePosition.topEnd(
                      top: -1,
                      end: 2,
                    ),
                    badgeContent: Text('$unreadMessagesCount'),
                    child: IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<MessagingChannelListView>(
                          builder: (_) => const MessagingChannelListView(),
                        ),
                      ),
                      icon: const Icon(
                        Icons.message_outlined,
                        size: 25,
                        semanticLabel: 'Messages',
                      ),
                    ),
                  );
                },
              ),
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showPullDownMenu(
                      context: context,
                      items: state.feedParamsList.entries.map((entry) {
                        return PullDownMenuItem(
                          onTap: () {
                            context.read<LoopFeedListBloc>().add(
                                  ChangeFeed(
                                    feed: entry.key,
                                  ),
                                );
                          },
                          title: entry.value.label,
                        );
                      }).toList(),
                      position: const Rect.fromLTWH(
                        10,
                        10,
                        100,
                        100,
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: feedParams.label,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const WidgetSpan(
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
