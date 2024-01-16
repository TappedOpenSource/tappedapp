import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/profile/components/badges_chip.dart';
import 'package:intheloopapp/ui/profile/components/epk_button.dart';
import 'package:intheloopapp/ui/profile/components/location_chip.dart';
import 'package:intheloopapp/ui/profile/components/more_options_button.dart';
import 'package:intheloopapp/ui/profile/components/social_media_icons.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/utils/linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoSliver extends StatelessWidget {
  const InfoSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final bio = state.visitedUser.bio;
        final occupations = state.visitedUser.occupations;
        final currPlace = state.place;
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
                if (currPlace != null)
                  CupertinoListTile(
                    leading: Icon(
                      CupertinoIcons.location,
                      color: theme.colorScheme.onSurface,
                    ),
                    title: LocationChip(
                      place: currPlace,
                    ),
                  ),
                if (occupations.isNotEmpty)
                  CupertinoListTile(
                    leading: const Icon(
                      CupertinoIcons.briefcase,
                    ),
                    title: Text(
                      occupations.join(', '),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                if (state.visitedUser.label != 'None')
                  CupertinoListTile(
                    leading: const Icon(
                      CupertinoIcons.tag,
                    ),
                    title: Text(
                      state.visitedUser.label,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                const CupertinoListTile(
                  leading: Icon(
                    CupertinoIcons.star,
                  ),
                  title: BadgesChip(),
                ),
                switch (state.visitedUser.epkUrl) {
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
            // if (bio.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(
            //       vertical: 8,
            //       horizontal: 16,
            //     ),
            //     child: Linkify(
            //       text: bio,
            //       maxLines: 6,
            //       style: const TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.normal,
            //         // color: Color(0xFF757575),
            //       ),
            //     ),
            //   ),
            // const EPKButton(),
            const SocialMediaIcons(),
          ],
        );
      },
    );
  }
}
