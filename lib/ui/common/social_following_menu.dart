import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialFollowingMenu extends StatelessWidget {
  const SocialFollowingMenu({
    required this.user,
    super.key,
  });

  final UserModel user;

  Widget _buildSocialRow(
    IconData icon,
    String label,
    int count,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        Text('$count $label'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final facebookFollowers = user.socialFollowing.facebookFollowers;
    final facebookHandle = user.socialFollowing.facebookHandle;
    final instagramFollowers = user.socialFollowing.instagramFollowers;
    final instagramHandle = user.socialFollowing.instagramHandle;
    final twitterFollowers = user.socialFollowing.twitterFollowers;
    final twitterHandle = user.socialFollowing.twitterHandle;
    final tiktokFollowers = user.socialFollowing.tiktokFollowers;
    final tiktokHandle = user.socialFollowing.tiktokHandle;
    final formatter = NumberFormat.compact(locale: 'en');

    if (facebookFollowers <= 0 &&
        instagramFollowers <= 0 &&
        twitterFollowers <= 0 &&
        tiktokFollowers <= 0) {
      return const SizedBox.shrink();
    }

    return CupertinoListSection.insetGrouped(
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
        if (facebookFollowers > 0)
          CupertinoListTile(
            onTap: switch (facebookHandle) {
              None() => null,
              Some(:final value) => () {
                  launchUrl(
                    Uri(
                      scheme: 'https',
                      path: 'facebook.com/$value',
                    ),
                  );
                }
            },
            leading: const Icon(
              FontAwesomeIcons.facebook,
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: theme.colorScheme.onSurface,
            ),
            title: Text(
              '${formatter.format(facebookFollowers)} followers',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        if (instagramFollowers > 0)
          CupertinoListTile(
            onTap: switch (instagramHandle) {
              None() => null,
              Some(:final value) => () {
                  launchUrl(
                    Uri(
                      scheme: 'https',
                      path: 'instagram.com/$value',
                    ),
                  );
                },
            },
            leading: const Icon(
              FontAwesomeIcons.instagram,
            ),
            trailing: switch (instagramHandle) {
              None() => null,
              Some(:final value) => Icon(
                CupertinoIcons.chevron_forward,
                color: theme.colorScheme.onSurface,
              ),
            },
            title: Text(
              '${formatter.format(instagramFollowers)} followers',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        if (twitterFollowers > 0)
          CupertinoListTile(
            onTap: switch (twitterHandle) {
              None() => null,
              Some(:final value) => () {
                  launchUrl(
                    Uri(
                      scheme: 'https',
                      path: 'twitter.com/$value',
                    ),
                  );
                },
            },
            trailing: switch (twitterHandle) {
              None() => null,
              Some(:final value) => Icon(
                CupertinoIcons.chevron_forward,
                color: theme.colorScheme.onSurface,
              ),
            },
            leading: const Icon(
              FontAwesomeIcons.twitter,
            ),
            title: Text(
              '${formatter.format(twitterFollowers)} followers',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        if (tiktokFollowers > 0)
          CupertinoListTile(
            onTap: switch (tiktokHandle) {
              None() => null,
              Some(:final value) => () {
                  launchUrl(
                    Uri(
                      scheme: 'https',
                      path: 'tiktok.com/@$value',
                    ),
                  );
                },
            },
            trailing: switch (tiktokHandle) {
              None() => null,
              Some(:final value) => Icon(
                CupertinoIcons.chevron_forward,
                color: theme.colorScheme.onSurface,
              ),
            },
            leading: const Icon(
              FontAwesomeIcons.tiktok,
            ),
            title: Text(
              '${formatter.format(tiktokFollowers)} followers',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
      ],
    );
  }
}
