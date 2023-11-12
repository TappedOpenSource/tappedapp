import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return badges.Badge(
          badgeContent: Text('${state.unreadActivitiesCount}'),
          showBadge: state.unreadActivities,
          position: badges.BadgePosition.topEnd(
            top: -1,
            end: 2,
          ),
          child: IconButton(
            onPressed: () => context.push(ActivitiesPage()),
            icon: Icon(
              CupertinoIcons.bell,
              color: Theme.of(context).colorScheme.outline,
              size: 24,
              semanticLabel: 'Notifications',
            ),
          ),
        );
      },
    );
  }
}
