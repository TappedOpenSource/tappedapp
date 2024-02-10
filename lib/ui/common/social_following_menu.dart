import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

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
    final instagramFollowers = user.socialFollowing.instagramFollowers;
    final twitterFollowers = user.socialFollowing.twitterFollowers;
    final tiktokFollowers = user.socialFollowing.tiktokFollowers;
    return Card(
      color: theme.colorScheme.onSurface.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (facebookFollowers > 0)
              _buildSocialRow(
                FontAwesomeIcons.facebook,
                'followers',
                facebookFollowers,
              ),
            if (instagramFollowers > 0)
              _buildSocialRow(
                FontAwesomeIcons.instagram,
                'followers',
                instagramFollowers,
              ),
            if (twitterFollowers > 0)
              _buildSocialRow(
                FontAwesomeIcons.twitter,
                'followers',
                twitterFollowers,
              ),
            if (tiktokFollowers > 0)
              _buildSocialRow(
                FontAwesomeIcons.tiktok,
                'followers',
                tiktokFollowers,
              ),
          ],
        ),
      ),
    );
  }
}
