import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/models/username.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.navigationBloc,
    required this.authenticationBloc,
    required this.onboardingBloc,
    required this.authRepository,
    required this.databaseRepository,
    required this.storageRepository,
    required this.places,
    required this.currentUser,
  }) : super(SettingsState());

  final UserModel currentUser;
  final NavigationBloc navigationBloc;
  final AuthenticationBloc authenticationBloc;
  final OnboardingBloc onboardingBloc;
  final AuthRepository authRepository;
  final DatabaseRepository databaseRepository;
  final StorageRepository storageRepository;
  final PlacesRepository places;

  void initUserData() {
    emit(
      state.copyWith(
        username: currentUser.username.toString(),
        artistName: currentUser.artistName,
        bio: currentUser.bio,
        genres: currentUser.performerInfo.asNullable()?.genres,
        label: currentUser.performerInfo.asNullable()?.label,
        occupations: currentUser.occupations,
        tiktokFollowers: currentUser.socialFollowing.tiktokFollowers,
        tiktokHandle: currentUser.socialFollowing.tiktokHandle.asNullable(),
        twitterFollowers: currentUser.socialFollowing.twitterFollowers,
        twitterHandle: currentUser.socialFollowing.twitterHandle.asNullable(),
        instagramFollowers: currentUser.socialFollowing.instagramFollowers,
        instagramHandle:
            currentUser.socialFollowing.instagramHandle.asNullable(),
        youtubeChannelId:
            currentUser.socialFollowing.youtubeChannelId.asNullable(),
        placeId: currentUser.location.asNullable()?.placeId,
        spotifyId:
            currentUser.performerInfo.asNullable()?.spotifyId.asNullable(),
        pushNotificationsDirectMessages:
            currentUser.pushNotifications.directMessages,
      ),
    );
  }

  Future<void> initPlace() async {
    try {
      final place = switch (currentUser.location) {
        None() => null,
        Some(:final value) => await places.getPlaceById(value.placeId),
      };
      emit(state.copyWith(place: place));
    } catch (e) {
      emit(state.copyWith());
    }
  }

  void changeBio(String value) => emit(state.copyWith(bio: value));

  void changeUsername(String value) => emit(state.copyWith(username: value));

  void changeArtistName(String value) =>
      emit(state.copyWith(artistName: value));

  void changeTwitter(String value) =>
      emit(state.copyWith(twitterHandle: value));

  void changeTwitterFollowers(int value) =>
      emit(state.copyWith(twitterFollowers: value));

  void changeInstagram(String value) =>
      emit(state.copyWith(instagramHandle: value));

  void changeInstagramFollowers(int value) => emit(
        state.copyWith(instagramFollowers: value),
      );

  void changeTikTik(String value) => emit(state.copyWith(tiktokHandle: value));

  void changeTikTokFollowers(int value) =>
      emit(state.copyWith(tiktokFollowers: value));

  void changeSpotify(String value) => emit(state.copyWith(spotifyId: value));

  void changeYoutube(String value) =>
      emit(state.copyWith(youtubeChannelId: value));

  void changePlace(PlaceData? place, String placeId) {
    emit(
      state.copyWith(
        place: place,
        placeId: placeId,
      ),
    );
  }

  void changeGenres(List<Genre> genres) => emit(
        state.copyWith(genres: genres),
      );

  void removeGenre(Genre genre) {
    emit(
      state.copyWith(
        genres: state.genres..remove(genre),
      ),
    );
  }

  void changeOccupations(List<String> value) => emit(
        state.copyWith(occupations: value),
      );

  void removeOccupation(String occupation) {
    emit(
      state.copyWith(
        occupations: state.occupations..remove(occupation),
      ),
    );
  }

  void changeLabel(String? value) => emit(state.copyWith(label: value));

  void updateEmail(String? input) => emit(
        state.copyWith(email: input),
      );

  void updatePassword(String? input) => emit(
        state.copyWith(password: input),
      );

  void changeDirectMsgPush({required bool selected}) =>
      emit(state.copyWith(pushNotificationsDirectMessages: selected));

  void changeAppReleaseEmail({required bool selected}) =>
      emit(state.copyWith(emailNotificationsAppReleases: selected));

  Future<void> handleImageFromGallery() async {
    try {
      final imageFile =
          await state.picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(state.copyWith(profileImage: File(imageFile.path)));
      }
    } catch (e) {
      // print(error);
    }
  }

  Future<void> saveProfile() async {
    // print(state.formKey);
    if (state.formKey.currentState == null) {
      return;
    }

    if (state.formKey.currentState!.validate() && !state.status.isInProgress) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final available = await databaseRepository.checkUsernameAvailability(
        state.username,
        currentUser.id,
      );

      if (!available) {
        throw HandleAlreadyExistsException('Username already exists');
      }

      final profilePictureUrl = state.profileImage != null
          ? Some(
              await storageRepository.uploadProfilePicture(
                currentUser.id,
                state.profileImage!,
              ),
            )
          : currentUser.profilePicture;

      final optionalPlace = Option.fromNullable(state.place);
      final location = switch (optionalPlace) {
        None() => const None<Location>(),
        Some(:final value) => Some<Location>(
            Location(
              placeId: value.placeId,
              geohash: value.geohash,
              lat: value.lat,
              lng: value.lng,
            ),
          ),
      };

      final newPerformerInfo = switch (currentUser.performerInfo) {
        None() => PerformerInfo(
            genres: state.genres,
            label: state.label ?? 'None',
            spotifyId: Option.fromNullable(state.spotifyId),
            rating: const None(),
            reviewCount: 0,
            pressKitUrl: const None<String>(),
          ),
        Some(:final value) => value.copyWith(
            genres: state.genres,
            label: state.label,
            spotifyId: Option.fromNullable(state.spotifyId),
          ),
      };

      final user = currentUser.copyWith(
        username: Username.fromString(state.username),
        artistName: state.artistName,
        bio: state.bio,
        performerInfo: Some(newPerformerInfo),
        socialFollowing: currentUser.socialFollowing.copyWith(
          twitterHandle: Option.fromNullable(state.twitterHandle),
          twitterFollowers: state.twitterFollowers,
          instagramHandle: Option.fromNullable(state.instagramHandle),
          instagramFollowers: state.instagramFollowers,
          tiktokHandle: Option.fromNullable(state.tiktokHandle),
          tiktokFollowers: state.tiktokFollowers,
          youtubeChannelId: Option.fromNullable(state.youtubeChannelId),
        ),
        pushNotifications: currentUser.pushNotifications.copyWith(
          directMessages: state.pushNotificationsDirectMessages,
        ),
        emailNotifications: currentUser.emailNotifications.copyWith(
          appReleases: state.emailNotificationsAppReleases,
        ),
        occupations: state.occupations,
        location: location,
        profilePicture: profilePictureUrl,
        // stripeConnectedAccountId: state.stripeConnectedAccountId,
      );

      onboardingBloc.add(UpdateOnboardedUser(user: user));
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      navigationBloc.pop();
    } else {
      // print('invalid');
    }
  }

  void logout() {
    authenticationBloc.add(LoggedOut());
  }

  Future<void> reauthWithGoogle() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await authRepository.reauthenticateWithGoogle();
      await deleteUser();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
    }
  }

  Future<void> reauthWithApple() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await authRepository.reauthenticateWithApple();
      await deleteUser();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
    }
  }

  Future<void> reauthWithCredentials() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await authRepository.reauthenticateWithCredentials(
        state.email,
        state.password,
      );
      await deleteUser();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
    }
  }

  Future<void> deleteUser() async {
    await authRepository.deleteUser();
    authenticationBloc.add(LoggedOut());
    navigationBloc
      ..add(const Pop())
      ..add(const Pop());
  }
}
