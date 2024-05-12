import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/spotify_track.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/utils/default_image.dart';
import 'package:url_launcher/url_launcher.dart';

class TopTracksSliver extends StatelessWidget {
  const TopTracksSliver({super.key});

  Widget _buildTrack(SpotifyTrack track) {
    final trackImage = track.album
        .map((album) => album.images)
        .getOrElse(() => [])
        .firstOrNull;

    final imageProvider = trackImage != null
        ? CachedNetworkImageProvider(trackImage.url)
        : getDefaultImage(Option.of(track.id));

    final aspectRatio =
        (trackImage?.width ?? 240) / (trackImage?.height ?? 240);

    return GestureDetector(
      onTap: () {
        final opener = switch (track.externalUrls) {
          None() => () {},
          Some(:final value) => () async {
              final spotifyLink = value['spotify'] as String?;

              if (spotifyLink == null) {
                return;
              }

              final daLink = Uri.parse(spotifyLink);
              await launchUrl(daLink);
            }
        };

        opener();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 180,
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        CupertinoIcons.play_fill,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                track.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.topTracks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Text(
                  'top tracks',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.topTracks.map(_buildTrack).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
