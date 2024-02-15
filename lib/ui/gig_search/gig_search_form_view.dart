import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/ui/forms/location_text_field.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_cubit.dart';
import 'package:intheloopapp/ui/settings/components/genre_selection.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class GigSearchFormView extends StatelessWidget {
  const GigSearchFormView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<GigSearchCubit, GigSearchState>(
      builder: (context, state) {
        return Scaffold(
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
                        'who',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      UserTile(
                        userId: currentUser.id,
                        user: Option.of(currentUser),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'where',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      LocationTextField(
                        initialPlace: state.place,
                        onChanged: (placeData, _) {
                          context
                              .read<GigSearchCubit>()
                              .updateLocation(placeData);
                        },
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
                        initialValue: state.genres,
                        onConfirm: (genres) {
                          context
                              .read<GigSearchCubit>()
                              .updateGenres(genres.whereType<Genre>().toList());
                        },
                      ),
                      // const SizedBox(height: 20),
                      // const Text(
                      //   'when',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w700,
                      //     fontSize: 20,
                      //   ),
                      // ),
                      // const Row(
                      //   children: [
                      //     Card(
                      //       child: Padding(
                      //         padding: EdgeInsets.all(8),
                      //         child: Text('date'),
                      //       ),
                      //     ),
                      //     Card(
                      //       child: Padding(
                      //         padding: EdgeInsets.all(8),
                      //         child: Text('flexible'),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CupertinoButton.filled(
                              onPressed: () {
                                context
                                    .read<GigSearchCubit>()
                                    .searchVenues()
                                    .catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      content: Text(
                                        error.toString(),
                                      ),
                                    ),
                                  );
                                });
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: const Text(
                                'search',
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
        );
      },
    );
  }
}
