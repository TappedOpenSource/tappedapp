import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/spotify_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/social_following.dart';
import 'package:intheloopapp/domains/models/spotify_artist.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/models/username.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/download_image.dart';
import 'package:intheloopapp/utils/sanitize_username.dart';

part 'onboarding_flow_state.dart';

class OnboardingFlowCubit extends Cubit<OnboardingFlowState> {
  OnboardingFlowCubit({
    required this.currentAuthUser,
    required this.spotify,
    required this.onboardingBloc,
    required this.navigationBloc,
    required this.authenticationBloc,
    required this.storageRepository,
    required this.databaseRepository,
  }) : super(
          OnboardingFlowState(
            currentUserId: currentAuthUser.uid,
            artistName: currentAuthUser.displayName ?? '',
          ),
        );

  final SpotifyRepository spotify;
  final OnboardingBloc onboardingBloc;
  final NavigationBloc navigationBloc;
  final AuthenticationBloc authenticationBloc;
  final StorageRepository storageRepository;
  final DatabaseRepository databaseRepository;
  final User currentAuthUser;

  void spotifyArtistChange(Option<SpotifyArtist> input) => switch (input) {
        None() => emit(
            state.copyWith(spotifyArtist: const None()),
          ),
        Some(:final value) => (() async {
            // get username from santitized spotify artist name
            final artistName = value.name;

            // get profile picture from spotify artist images
            final profilePicture = value.images.isNotEmpty
                ? Option.of(value.images.first.url)
                : const None();

            final profilePicFile = await switch (profilePicture) {
              Some(:final value) => () async {
                  final file = await downloadImage(value);
                  return file;
                }(),
              None() => Future.value(const None()),
            };

            emit(
              state.copyWith(
                spotifyArtist: Option.of(value),
                artistName: artistName.toNullable(),
                pickedPhoto: profilePicFile,
              ),
            );
          })()
      };

  void artistNameChange(String input) => emit(
        state.copyWith(
          artistName: input,
        ),
      );

  void tiktokHandleChange(String input) => emit(
        state.copyWith(
          tiktokHandle: input,
        ),
      );

  void tiktokFollowersChange(int input) => emit(
        state.copyWith(
          tiktokFollowers: input,
        ),
      );

  void instagramHandleChange(String input) => emit(
        state.copyWith(
          instagramHandle: input,
        ),
      );

  void instagramFollowersChange(int input) => emit(
        state.copyWith(
          instagramFollowers: input,
        ),
      );

  // ignore: avoid_positional_boolean_parameters
  void eulaChange(bool input) => emit(
        state.copyWith(
          eula: input,
        ),
      );

  Future<void> fetchSpotifyInfo(Option<String> spotifyUrl) async {
    emit(
      state.copyWith(
        artistName: '',
        photoUrl: const None(),
      ),
    );

    final res = await switch (spotifyUrl) {
      None() => Future<Option<SpotifyArtist>>.value(const None()),
      Some(:final value) => (() async {
          if (value.isEmpty) {
            return const None();
          }

          final spotifyId = Uri.parse(value).pathSegments.last;
          final spotifyArtist = await spotify.getArtistById(spotifyId);
          return spotifyArtist;
        })(),
    };

    if (res.isNone()) {
      return;
    }
  }

  Future<void> handleImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final imageFile = await picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(
          state.copyWith(
            pickedPhoto: Option.of(File(imageFile.path)),
          ),
        );
      }
    } catch (e) {
      // print(error);
    }
  }

  Future<void> nextQuestion(int index) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'onboarding_next_question',
      parameters: {
        'index': index,
      },
    );
  }

  Future<void> finishOnboarding() async {
    if (state.status.isInProgress) {
      return;
    }

    if (state.isNotValid) {
      return;
    }

    if (!state.eula) {
      throw Exception('you must agree to the EULA');
    }

    final usernameCandidate = sanitizeUsername(state.artistName);

    // check if username exists, if it does add a number to the end
    final username = await switch (usernameCandidate.isEmpty) {
      true => Future.value(''),
      false => (() async {
          final usernameAvailable =
              await databaseRepository.checkUsernameAvailability(
            usernameCandidate,
            currentAuthUser.uid,
          );

          final sinceEpoch = DateTime.now().millisecondsSinceEpoch.toString();
          final lastFour = sinceEpoch.substring(sinceEpoch.length - 4);
          return usernameAvailable
              ? usernameCandidate
              : '$usernameCandidate$lastFour';
        })(),
    };

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final profilePictureUrl = await switch (state.pickedPhoto) {
        Some(:final value) => () async {
            final url = await storageRepository.uploadProfilePicture(
              currentAuthUser.uid,
              value,
            );
            return Option.of(url);
          }(),
        None() => Future.value(const None()),
      };

      final genres = switch (state.spotifyArtist) {
        Some(:final value) => value.genres,
        None() => <String>[],
      };

      final tiktokHandle = state.tiktokHandle.isNotEmpty
          ? Option.of(state.tiktokHandle)
          : const None();
      final instagramHandle = state.instagramHandle.isNotEmpty
          ? Option.of(state.instagramHandle)
          : const None();
      final emptyUser = UserModel.empty();
      final currentUser = emptyUser.copyWith(
        id: currentAuthUser.uid,
        email: currentAuthUser.email ?? '',
        username: Username.fromString(username),
        artistName: state.artistName,
        profilePicture: profilePictureUrl,
        socialFollowing: SocialFollowing(
          tiktokHandle: tiktokHandle,
          tiktokFollowers: state.tiktokFollowers,
          instagramHandle: instagramHandle,
          instagramFollowers: state.instagramFollowers,
        ),
        performerInfo: Option.of(
          PerformerInfo(
            genres: genres,
          ),
        ),
      );

      await databaseRepository.createUser(currentUser);

      await Future<void>.delayed(const Duration(seconds: 2));

      onboardingBloc.add(FinishOnboarding(user: currentUser));
    } catch (e, s) {
      logger.error('error finishing onboarding', error: e, stackTrace: s);
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
