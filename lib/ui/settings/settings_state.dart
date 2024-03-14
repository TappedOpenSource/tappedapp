part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default('') String username,
    @Default('') String artistName,
    @Default('') String bio,
    @Default([]) List<Genre> genres,
    @Default('independent') String label,
    @Default([]) occupations,
    String? placeId,
    String? twitterHandle,
    int? twitterFollowers,
    String? instagramHandle,
    int? instagramFollowers,
    String? tiktokHandle,
    int? tiktokFollowers,
    String? soundcloudHandle,
    String? audiusHandle,
    String? spotifyUrl,
    String? youtubeChannelId,
    @Default(None()) Option<File> profileImage,
    @Default(None()) Option<File> pressKitFile,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(true) bool pushNotificationsDirectMessages,
    @Default(true) bool emailNotificationsAppReleases,
    @Default('') String email,
    @Default('') String password,
    @Default(None()) Option<PlaceData> place,
    required GlobalKey<FormState> formKey,
  }) = _SettingsState;
}
