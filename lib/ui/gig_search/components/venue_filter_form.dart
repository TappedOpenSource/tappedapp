import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/forms/location_text_field.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_cubit.dart';
import 'package:intheloopapp/ui/settings/components/genre_selection.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/premium_builder.dart';

class VenueFilterForm extends StatelessWidget {
  const VenueFilterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumBuilder(
      builder: (context, isPremium) {
        return BlocBuilder<AppThemeCubit, bool>(
          builder: (context, isDark) {
            return BlocBuilder<GigSearchCubit, GigSearchState>(
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: theme.colorScheme.background,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: CurrentUserBuilder(
                      builder: (context, currentUser) {
                        return CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'reach out to thousands of venues in a matter of seconds to get booked for a show',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
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
                                      try {
                                        context
                                            .read<GigSearchCubit>()
                                            .updateLocation(placeData);
                                      } catch (e, s) {
                                        logger.e(
                                          'Error updating location',
                                          error: e,
                                          stackTrace: s,
                                        );
                                      }
                                    },
                                  ),
                                  if (state.place.isNone())
                                    const Text(
                                      'please select a city',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
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
                                      context.read<GigSearchCubit>().updateGenres(
                                        genres.whereType<Genre>().toList(),);
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const Text(
                                        'capacity',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                title: const Text('Capacity'),
                                                content: const Text(
                                                  'we have the capacity range defaulted to numbers that align with your previous booking history',
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    child: const Text('Ok'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Icon(
                                          Icons.info_outline,
                                          size: 16,
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(state.capacityRangeStart.toString()),
                                      Expanded(
                                        child: RangeSlider(
                                          values: state.capacityRange,
                                          max: maxCapacity,
                                          onChanged: (values) {
                                            context
                                                .read<GigSearchCubit>()
                                                .updateCapacity(values);
                                          },
                                          activeColor: theme.colorScheme.primary,
                                          inactiveColor: theme.colorScheme.onSurface
                                              .withOpacity(0.4),
                                          divisions: maxCapacity.toInt(),
                                          labels: RangeLabels(
                                            state.capacityRangeStart.toString(),
                                            state.capacityRangeEnd.toString(),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        state.capacityRangeEnd == maxCapacity
                                            ? '${maxCapacity.round()}+'
                                            : state.capacityRangeEnd.toString(),
                                      ),
                                    ],
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
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
