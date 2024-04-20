import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/data/spotify_repository.dart';
import 'package:intheloopapp/domains/spotify_bloc/spotify_bloc.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class ConnectSpotifyButton extends StatelessWidget {
  const ConnectSpotifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spotifyRepo = context.read<SpotifyRepository>();
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocBuilder<SpotifyBloc, SpotifyState>(
          builder: (context, state) {
            return switch (state) {
              SpotifyInitial() => const SizedBox(),
              SpotifyAuthenticated() => CupertinoButton(
                  onPressed: () {
                    context.read<SpotifyBloc>().add(
                          RefreshConnection(
                            currentUserId: currentUser.id,
                          ),
                        );
                  },
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.spotify,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'refresh spotify',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              SpotifyUnauthenticated() => CupertinoButton(
                  onPressed: spotifyRepo.signInWithSpotify,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.spotify,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'connect spotify',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            };
          },
        );
      },
    );
  }
}
