import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/loop_feed_list_bloc/loop_feed_list_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/error/error_view.dart';
import 'package:intheloopapp/ui/views/loop_feed/loop_feed_view.dart';
import 'package:intheloopapp/ui/widgets/profile_view/notification_icon_button.dart';
import 'package:pull_down_button/pull_down_button.dart';

class LoopFeedsListView extends StatelessWidget {
  const LoopFeedsListView({super.key});

  @override
  Widget build(BuildContext context) {
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
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const WidgetSpan(
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const NotificationIconButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}
