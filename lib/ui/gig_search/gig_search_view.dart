import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/gig_search/components/city_selection.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_cubit.dart';
import 'package:intheloopapp/ui/settings/components/genre_selection.dart';
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
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: CurrentUserBuilder(
              builder: (context, currentUser) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'where',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    CitySelection(
                      onConfirm: (_) {},
                      initialValue: [],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'genres',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    GenreSelection(
                      initialValue: currentUser.performerInfo
                          .map((info) => info.genres)
                          .getOrElse(() => []),
                      onConfirm: (_) {},
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'when',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('date'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('flexible'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'who',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    UserTile(
                      userId: currentUser.id,
                      user:Option.of(currentUser),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CupertinoButton.filled(
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: const Text(
                              'submit',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
