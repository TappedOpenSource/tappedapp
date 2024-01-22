import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class BottomToolbar extends StatelessWidget {
  BottomToolbar({
    required this.user,
    super.key,
  });

  final UserModel user;
  final cupertinoTabController = CupertinoTabController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final streamClient = StreamChat.of(context).client;
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return CupertinoTabBar(
          onTap: (index) {
            context.changeTab(selectedTab: index);
          },
          activeColor: theme.primaryColor,
          inactiveColor:
              theme.bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey,
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          // backgroundColor: Colors.transparent,
          // inactiveColor: Colors.white,
          currentIndex: state.selectedTab,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.waveform_path,
              ),
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onDoubleTap: () {
                  context.changeTab(selectedTab: 1);
                  context.push(
                    const SearchPage(),
                  );
                },
                child: const Icon(CupertinoIcons.search),
              ),
            ),
            BottomNavigationBarItem(
              icon: BlocBuilder<BookingsBloc, BookingsState>(
                builder: (context, state) {
                  final pendingBookings = state.bookings.where((booking) {
                    return (booking.status == BookingStatus.pending) &&
                        (user.id == booking.requesteeId);
                  }).toList();
                  return badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -4, end: -5),
                    showBadge: pendingBookings.isNotEmpty,
                    badgeContent: Text(
                      pendingBookings.length.toString(),
                    ),
                    child: const Icon(
                      CupertinoIcons.tickets,
                    ),
                  );
                },
              ),
            ),
            BottomNavigationBarItem(
              icon: StreamBuilder<int?>(
                stream: streamClient
                    .on()
                    .where((event) => event.totalUnreadCount != null)
                    .map(
                      (event) => event.totalUnreadCount,
                    ),
                initialData: streamClient.state.totalUnreadCount,
                builder: (context, snapshot) {
                  final unreadMessagesCount = snapshot.data ?? 0;

                  return badges.Badge(
                    showBadge: unreadMessagesCount > 0,
                    position: badges.BadgePosition.topEnd(
                      top: -1,
                      end: 2,
                    ),
                    // badgeContent: Text('$unreadMessagesCount'),
                    child: const Icon(
                      CupertinoIcons.chat_bubble,
                      size: 24,
                      semanticLabel: 'Messages',
                    ),
                  );
                },
              ),
            ),
            BottomNavigationBarItem(
              activeIcon: Container(
                height: 35,
                width: 35,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(35.0 / 2),
                ),
                child: UserAvatar(
                  radius: 45,
                  imageUrl: user.profilePicture.asNullable(),
                ),
              ),
              icon: Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: theme.bottomNavigationBarTheme.unselectedItemColor,
                  borderRadius: BorderRadius.circular(30.0 / 2),
                ),
                child: UserAvatar(
                  radius: 45,
                  imageUrl: user.profilePicture.asNullable(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
