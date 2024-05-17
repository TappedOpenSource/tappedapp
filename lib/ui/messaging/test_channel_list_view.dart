import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/messaging/search_text_field.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({super.key});

  @override
  State<ChannelList> createState() => _ChannelList();
}

class _ChannelList extends State<ChannelList> {
  final ScrollController _scrollController = ScrollController();

  Widget _buildEmptyFeed(BuildContext context) {
    return PremiumBuilder(
      builder: (context, isPremium) {
        return SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/classic_edm.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 12,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Column(
                          children: [
                            const EasterEggPlaceholder(),
                            const Text(
                              'start talking to venues and get the conversation started!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (!isPremium)
                              CupertinoButton(
                                borderRadius: BorderRadius.circular(15),
                                child: const Text(
                                  'upgrade',
                                ),
                                onPressed: () => context.push(
                                  PaywallPage(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // late final StreamChannelListController _messageSearchListController =
  // StreamChannelListController(
  //   client: StreamChat.of(context).client,
  //   filter: Filter.and([
  //     Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
  //     Filter.autoComplete('member.user.name', _controller.text),
  //   ]),
  //   limit: 5,
  // );
  //
  late final TextEditingController _controller = TextEditingController()
    ..addListener(_channelQueryListener);

  String _searchQuery = "";
  bool _isSearchActive = false;
  Timer? _debounce;

  void _channelQueryListener() {
    final client = StreamChat.of(context).client;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        // _messageSearchListController.searchQuery = _controller.text;
        // _messageSearchListController.filter = Filter.and([
        //   Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
        //   Filter.query('member.user.name', _controller.text),
        // ]);
        setState(() {
          _searchQuery = _controller.text;
          _isSearchActive = _controller.text.isNotEmpty;
        });
        // if (_isSearchActive) _messageSearchListController.doInitialLoad();
      }
    });
  }

  late final _channelListController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    limit: 30,
  );

  @override
  void dispose() {
    _controller.removeListener(_channelQueryListener);
    _controller.dispose();
    _scrollController.dispose();
    _channelListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        if (_isSearchActive) {
          _controller.clear();
          setState(() => _isSearchActive = false);
        }
      },
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            FocusScope.of(context).unfocus();
          }
          return true;
        },
        child: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: false,
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: SearchTextField(
                controller: _controller,
                showCloseButton: _isSearchActive,
              ),
            ),
          ],
          body: _isSearchActive
              ? StreamChannelListView(
            controller: StreamChannelListController(
              client: StreamChat.of(context).client,
              filter: Filter.and([
                Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
                if (_searchQuery.isNotEmpty)
                  Filter.autoComplete('member.user.name', _searchQuery),
              ]),
              limit: 5,
            ),
            emptyBuilder: (_) {
              return LayoutBuilder(
                builder: (context, viewportConstraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: StreamSvgIcon.search(
                                size: 96,
                                color: Colors.grey,
                              ),
                            ),
                            const Text(
                              'no results',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            itemBuilder: (
                context,
                messageResponses,
                index,
                defaultWidget,
                ) {
              return defaultWidget.copyWith(
                onTap: () async {
                  final nav = context.nav;
                  final channel = messageResponses[index];
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (channel.state == null) {
                    await channel.watch();
                  }

                  nav.push(
                    StreamChannelPage(
                      channel: channel,
                    ),
                  );
                },
              );
            },
          )
              : SlidableAutoCloseBehavior(
            // closeWhenOpened: true,
            child: RefreshIndicator(
              onRefresh: _channelListController.refresh,
              child: StreamChannelListView(
                controller: _channelListController,
                itemBuilder: (context, channels, index, defaultWidget) {
                  final chatTheme = StreamChatTheme.of(context);
                  final backgroundColor = chatTheme.colorTheme.inputBg;
                  final channel = channels[index];
                  final canDeleteChannel = channel.ownCapabilities
                      .contains(PermissionType.deleteChannel);
                  return Slidable(
                    groupTag: 'channels-actions',
                    endActionPane: ActionPane(
                      extentRatio: canDeleteChannel ? 0.40 : 0.20,
                      motion: const BehindMotion(),
                      children: [
                        CustomSlidableAction(
                          onPressed: (_) {
                            showChannelInfoModalBottomSheet<void>(
                              context: context,
                              channel: channel,
                              onViewInfoTap: () {
                                Navigator.pop(context);
                                // Navigate to info screen
                              },
                            );
                          },
                          backgroundColor: backgroundColor,
                          child: const Icon(Icons.more_horiz),
                        ),
                        if (canDeleteChannel)
                          CustomSlidableAction(
                            backgroundColor: backgroundColor,
                            child: StreamSvgIcon.delete(
                              color: chatTheme.colorTheme.accentError,
                            ),
                            onPressed: (_) async {
                              final res = await showConfirmationBottomSheet(
                                context,
                                title: 'delete conversation',
                                question:
                                'are you sure you want to delete this conversation?',
                                okText: 'delete',
                                cancelText: 'cancel',
                                icon: StreamSvgIcon.delete(
                                  color: chatTheme.colorTheme.accentError,
                                ),
                              );
                              if (res == true) {
                                await _channelListController.deleteChannel(channel);
                              }
                            },
                          ),
                        // CustomSlidableAction(
                        //   backgroundColor: backgroundColor,
                        //   onPressed: (_) {
                        //     showChannelInfoModalBottomSheet(
                        //       context: context,
                        //       channel: channel,
                        //       onViewInfoTap: () {
                        //         Navigator.pop(context);
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) {
                        //               final isOneToOne =
                        //                   channel.memberCount == 2 &&
                        //                       channel.isDistinct;
                        //               return StreamChannel(
                        //                 channel: channel,
                        //                 child: isOneToOne
                        //                     ? ChatInfoScreen(
                        //                   messageTheme: chatTheme
                        //                       .ownMessageTheme,
                        //                   user: channel
                        //                       .state!.members
                        //                       .where((m) =>
                        //                   m.userId !=
                        //                       channel
                        //                           .client
                        //                           .state
                        //                           .currentUser!
                        //                           .id)
                        //                       .first
                        //                       .user,
                        //                 )
                        //                     : GroupInfoScreen(
                        //                   messageTheme: chatTheme
                        //                       .ownMessageTheme,
                        //                 ),
                        //               );
                        //             },
                        //           ),
                        //         );
                        //       },
                        //     );
                        //   },
                        //   child: const Icon(Icons.more_horiz),
                        // ),
                        // if (canDeleteChannel)
                        //   CustomSlidableAction(
                        //     backgroundColor: backgroundColor,
                        //     child: StreamSvgIcon.delete(
                        //       color: chatTheme.colorTheme.accentError,
                        //     ),
                        //     onPressed: (_) async {
                        //       final res =
                        //       await showConfirmationBottomSheet(
                        //         context,
                        //         title: 'Delete Conversation',
                        //         question:
                        //         'Are you sure you want to delete this conversation?',
                        //         okText: 'Delete',
                        //         cancelText: 'Cancel',
                        //         icon: StreamSvgIcon.delete(
                        //           color: chatTheme.colorTheme.accentError,
                        //         ),
                        //       );
                        //       if (res) {
                        //         await _channelListController
                        //             .deleteChannel(channel);
                        //       }
                        //     },
                        //   ),
                      ],
                    ),
                    child: defaultWidget,
                  );
                },
                onChannelTap: (channel) {
                  context.push(StreamChannelPage(channel: channel));
                },
                emptyBuilder: _buildEmptyFeed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}