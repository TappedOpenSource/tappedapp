import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_cubit.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:skeletons/skeletons.dart';

class GigSearchView extends StatelessWidget {
  const GigSearchView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<GigSearchCubit>(
      create: (context) => GigSearchCubit(),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: const TappedAppBar(
          title: 'Opportunities',
        ),
        body: Column(
          children: [
            Text('where'),
            Text('richmond, dc, nyc, etc'),
            Text('genres'),
            Text('rock, pop, rap, etc'),
            Text('when'),
            Text('date, flexible'),
            Text('who'),
            CurrentUserBuilder(
              errorWidget: SkeletonListTile(),
              builder: (context, currentUser) {
                return UserTile(
                  userId: currentUser.id,
                  user: Some(currentUser),
                );
              },
            ),
            CupertinoButton.filled(child: Text('get booked'), onPressed: (){}),
          ],
        ),
      ),
    );
  }
}
