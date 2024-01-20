import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({super.key});

  Widget? _socialMediaIcon({
    required Color color,
    required Icon icon,
    void Function()? onTap,
  }) {
    return GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: icon,
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final socialFollowing = state.visitedUser.socialFollowing;
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              switch (socialFollowing.twitterHandle) {
                None() => null,
                Some(:final value) => _socialMediaIcon(
                  color: Colors.blue,
                  icon: const Icon(
                    FontAwesomeIcons.twitter,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    launchUrl(
                      Uri(
                        scheme: 'https',
                        path: 'twitter.com/$value',
                      ),
                    );
                  },
                ),
              },
              switch (socialFollowing.instagramHandle) {
                None() => null,
                Some(:final value) => _socialMediaIcon(
                  color: Colors.pink,
                  icon: const Icon(
                    FontAwesomeIcons.instagram,
                    color: Colors.pink,
                  ),
                  onTap: () {
                    launchUrl(
                      Uri(
                        scheme: 'https',
                        path: 'instagram.com/$value',
                      ),
                    );
                  },
                ),
              },
              switch (socialFollowing.tiktokHandle) {
                None() => null,
                Some(:final value) => _socialMediaIcon(
                  color: Colors.black,
                  icon: const Icon(FontAwesomeIcons.tiktok),
                  onTap: () {
                    launchUrl(
                      Uri(
                        scheme: 'https',
                        path: 'tiktok.com/@$value',
                      ),
                    );
                  },
                ),
              },
              switch (socialFollowing.youtubeChannelId) {
                None() => null,
                Some(:final value) => _socialMediaIcon(
                  color: Colors.red,
                  icon: Icon(
                    FontAwesomeIcons.youtube,
                    color: Colors.red.shade700,
                  ),
                  onTap: () {
                    launchUrl(
                      Uri(
                        scheme: 'https',
                        path: 'youtube.com/channel/$value',
                      ),
                    );
                  },
                ),
              },
            ].where((element) => element != null).whereType<Widget>().toList(),
          ),
        );
      },
    );
  }
}
