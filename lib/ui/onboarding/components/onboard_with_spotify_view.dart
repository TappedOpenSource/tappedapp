import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intheloopapp/domains/models/spotify_artist.dart';
import 'package:intheloopapp/ui/forms/spotify_text_field.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardWithSpotifyView extends StatefulWidget {
  const OnboardWithSpotifyView({
    this.initialValue,
    this.onChanged,
    super.key,
  });

  final String? initialValue;
  final void Function(SpotifyArtist)? onChanged;

  @override
  State<OnboardWithSpotifyView> createState() => _OnboardWithSpotifyViewState();
}

class _OnboardWithSpotifyViewState extends State<OnboardWithSpotifyView> {
  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;
  Option<SpotifyArtist> _spotifyArtist = const None();
  late String _spotifyUrl;

  @override
  void initState() {
    _spotifyUrl = widget.initialValue ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spotify = context.spotify;
    return switch (_status) {
      FormzSubmissionStatus.failure => const Center(child: Text('oops')),
      FormzSubmissionStatus.canceled => const Center(child: Text('oops')),
      FormzSubmissionStatus.success => Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: switch (_spotifyArtist) {
            None() => const Center(
                child: Text('something went wrong'),
              ),
            Some(:final value) => Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 46,
                  bottom: 52,
                ),
                child: Column(
                  children: [
                    const SizedBox(width: double.infinity),
                    if (value.images.isNotEmpty)
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              value.images.first.url,
                            ),
                          ),
                        ),
                      ),
                    Text(
                      value.name.getOrElse(() => '<artist name unknown>'),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        children: value.genres.map((genre) {
                          return Chip(label: Text(genre));
                        }).toList(),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoButton.filled(
                            onPressed: () {
                              widget.onChanged?.call(value);
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: const Text(
                              'confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
          },
        ),
      FormzSubmissionStatus.inProgress => Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/edm_loop.gif',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: ColoredBox(
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Text(
                        'fetching your info from spotify...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      FormzSubmissionStatus.initial => SafeArea(
          child: Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(
              title: const Text('onboard with spotify'),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SpotifyTextField(
                    initialValue: widget.initialValue,
                    onChanged: (value) => setState(() {
                      _spotifyUrl = value;
                    }),
                  ),
                  GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse(
                        'https://tappedapp.notion.site/how-do-i-get-my-spotify-url-2d1250547a044071becbe43763a77583',
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'how do I find my spotify artist url?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.open_in_new,
                            color: Colors.blue,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton.filled(
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            try {
                              if (_spotifyUrl.isEmpty) {
                                throw Exception(
                                  "spotify url can't be empty",
                                );
                              }

                              final uri = Uri.tryParse(_spotifyUrl);
                              if (uri == null) {
                                throw Exception(
                                  "url isn't formatted correctly",
                                );
                              }

                              final spotifyId =
                                  Uri.parse(_spotifyUrl).pathSegments.lastOrNull;
                              if (spotifyId == null) {
                                throw Exception(
                                  "url isn't formatted correctly",
                                );
                              }

                              setState(() {
                                _status = FormzSubmissionStatus.inProgress;
                              });

                              final res =
                                  await spotify.getArtistById(spotifyId);

                              return switch (res) {
                                None() => setState(() {
                                    _status = FormzSubmissionStatus.failure;
                                  }),
                                Some(:final value) => (() {
                                    setState(() {
                                      _spotifyArtist = Option.of(value);
                                      _status = FormzSubmissionStatus.success;
                                    });
                                    // widget.onChanged?.call(value);
                                  })(),
                              };
                            } catch (e, s) {
                              logger.e(
                                'error fetching spotify',
                                error: e,
                                stackTrace: s,
                              );
                              setState(() {
                                _status = FormzSubmissionStatus.failure;
                              });
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: const Text(
                            'done',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: const Text(
                            'cancel',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    };
  }
}
