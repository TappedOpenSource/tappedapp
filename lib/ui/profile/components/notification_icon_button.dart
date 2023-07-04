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
        return GestureDetector(
          onTap: () => context.push(ActivitiesPage()),
          child: badges.Badge(
            onTap: () => context.push(ActivitiesPage()),
            badgeContent: Text('${state.unreadActivitiesCount}'),
            showBadge: state.unreadActivities,
            child: Icon(
              CupertinoIcons.heart,
              color: Theme.of(context).colorScheme.outline,
              size: 30,
              semanticLabel: 'Notifications',
            ),
          ),
        );
      },
    );
  }
}
