part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required GlobalKey<FormState> formKey, @Default(true) bool isPerformer,
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
    String? youtubeHandle,
    String? spotifyUrl,
    @Default(None()) Option<File> profileImage,
    @Default(None()) Option<File> pressKitFile,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(true) bool pushNotificationsDirectMessages,
    @Default(true) bool emailNotificationsAppReleases,
    @Default(true) bool emailNotificationsDirectMessages,
    @Default('') String email,
    @Default('') String password,
    @Default(None()) Option<PlaceData> place,
  }) = _SettingsState;
}
