import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/profile/components/more_options_button.dart';
import 'package:intheloopapp/ui/profile/components/social_media_icons.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/utils/admin_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoSliver extends StatelessWidget {
  const InfoSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final occupations = state.visitedUser.occupations;
        final performerInfo = state.visitedUser.performerInfo.toNullable();
        final genres = performerInfo?.genres ?? [];
        final label = performerInfo?.label ?? 'None';
        final pressKitUrl = performerInfo?.pressKitUrl ?? const None();
        final currPlace = state.place;
        final idealPerformerProfile =
            state.visitedUser.venueInfo.flatMap((t) => t.idealPerformerProfile);
        final bookingEmail = state.visitedUser.venueInfo
            .flatMap((t) => t.bookingEmail)
            .toNullable();
        return AdminBuilder(
          builder: (context, isAdmin) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoListSection.insetGrouped(
                  backgroundColor: theme.colorScheme.background,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.onBackground.withOpacity(0.1),
                        width: 0.5,
                      ),
                    ),
                  ),
                  children: [
                    CupertinoListTile(
                      leading: const Icon(
                        CupertinoIcons.at,
                      ),
                      title: Text(
                        state.visitedUser.username.toString(),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isAdmin && bookingEmail != null)
                      CupertinoListTile(
                        leading: const Icon(
                          CupertinoIcons.mail,
                        ),
                        title: Text(
                          bookingEmail,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    if (currPlace != null)
                      CupertinoListTile(
                        leading: Icon(
                          CupertinoIcons.location,
                          color: theme.colorScheme.onSurface,
                        ),
                        title: Text(
                          getAddressComponent(currPlace.addressComponents),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    switch (state.visitedUser.venueInfo) {
                      None() => const SizedBox.shrink(),
                      Some(:final value) => switch (value.capacity) {
                          None() => const SizedBox.shrink(),
                          Some(:final value) => CupertinoListTile(
                              leading: const Icon(
                                CupertinoIcons.person_2_alt,
                              ),
                              title: Text(
                                '$value capacity',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                        },
                    },
                    if (occupations.isNotEmpty)
                      CupertinoListTile(
                        leading: const Icon(
                          CupertinoIcons.briefcase,
                        ),
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            occupations.join(', '),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    if (genres.isNotEmpty)
                      CupertinoListTile(
                        leading: const Icon(
                          CupertinoIcons.music_note,
                        ),
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            genres.map((e) => e.name).join(', '),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    if (label != 'None')
                      CupertinoListTile(
                        leading: const Icon(
                          CupertinoIcons.tag,
                        ),
                        title: Text(
                          label,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    switch (pressKitUrl) {
                      None() => const SizedBox.shrink(),
                      Some(:final value) => CupertinoListTile.notched(
                          title: Text(
                            'EPK',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          trailing: const Icon(CupertinoIcons.chevron_forward),
                          onTap: () async {
                            await launchUrl(Uri.parse(value));
                          },
                        ),
                    },
                    switch (idealPerformerProfile) {
                      None() => const SizedBox.shrink(),
                      Some(:final value) => CupertinoListTile(
                          title: Text(
                            'Ideal Performer Profile',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          trailing: const Icon(CupertinoIcons.chevron_forward),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (context) {
                                return SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 20,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text(
                                            'what kind of performers do they normally book?',
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            value,
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    },
                    CupertinoListTile(
                      title: Text(
                        'More Options',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      trailing: const MoreOptionsButton(),
                    ),
                  ],
                ),
                const SocialMediaIcons(),
              ],
            );
          },
        );
      },
    );
  }
}
