part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  SettingsState({
    this.username = '',
    this.artistName = '',
    this.bio = '',
    this.genres = const [],
    this.label,
    this.occupations = const [],
    this.placeId,
    this.twitterHandle,
    this.instagramHandle,
    this.tiktokHandle,
    this.spotifyId,
    this.youtubeChannelId,
    this.profileImage,
    this.status = FormzSubmissionStatus.initial,
    this.pushNotificationsLikes = true,
    this.pushNotificationsComments = true,
    this.pushNotificationsFollows = true,
    this.pushNotificationsDirectMessages = true,
    this.pushNotificationsITLUpdates = true,
    this.emailNotificationsAppReleases = true,
    this.emailNotificationsITLUpdates = true,
    this.email = '',
    this.password = '',
    this.services = const [],
    Place? place,
    ImagePicker? picker,
    GlobalKey<FormState>? formKey,
  }) {
    this.picker = picker ?? ImagePicker();
    this.formKey = formKey ?? GlobalKey<FormState>(debugLabel: 'settings');
    this.place = place ?? const Place();
  }

  final String username;
  final String artistName;
  final List<Genre> genres;
  final List<String> occupations;
  final String? label;

  final String bio;

  final String? twitterHandle;
  final String? instagramHandle;
  final String? tiktokHandle;
  final String? spotifyId;
  final String? youtubeChannelId;
  final File? profileImage;
  final FormzSubmissionStatus status;

  final String? placeId;
  late final Place? place;

  late final ImagePicker picker;
  late final GlobalKey<FormState> formKey;

  final bool pushNotificationsLikes;
  final bool pushNotificationsComments;
  final bool pushNotificationsFollows;
  final bool pushNotificationsDirectMessages;
  final bool pushNotificationsITLUpdates;
  final bool emailNotificationsAppReleases;
  final bool emailNotificationsITLUpdates;

  final String email;
  final String password;

  final List<Service> services;

  @override
  List<Object?> get props => [
        username,
        artistName,
        bio,
        genres,
        label,
        occupations,
        place,
        placeId,
        twitterHandle,
        instagramHandle,
        tiktokHandle,
        spotifyId,
        youtubeChannelId,
        profileImage,
        status,
        pushNotificationsLikes,
        pushNotificationsComments,
        pushNotificationsFollows,
        pushNotificationsDirectMessages,
        pushNotificationsITLUpdates,
        emailNotificationsAppReleases,
        emailNotificationsITLUpdates,
        email,
        password,
        services,
      ];

  SettingsState copyWith({
    String? username,
    String? artistName,
    String? bio,
    List<Genre>? genres,
    List<String>? occupations,
    String? label,
    Place? place,
    String? placeId,
    String? twitterHandle,
    String? instagramHandle,
    String? tiktokHandle,
    String? spotifyId,
    String? youtubeChannelId,
    File? profileImage,
    FormzSubmissionStatus? status,
    bool? pushNotificationsLikes,
    bool? pushNotificationsComments,
    bool? pushNotificationsFollows,
    bool? pushNotificationsDirectMessages,
    bool? pushNotificationsITLUpdates,
    bool? emailNotificationsAppReleases,
    bool? emailNotificationsITLUpdates,
    String? email,
    String? password,
    List<Service>? services,
  }) {
    return SettingsState(
      username: username ?? this.username,
      artistName: artistName ?? this.artistName,
      bio: bio ?? this.bio,
      genres: genres ?? this.genres,
      occupations: occupations ?? this.occupations,
      label: label ?? this.label,
      place: place ?? this.place,
      placeId: placeId ?? this.placeId,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      spotifyId: spotifyId ?? this.spotifyId,
      youtubeChannelId: youtubeChannelId ?? this.youtubeChannelId,
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,
      pushNotificationsLikes:
          pushNotificationsLikes ?? this.pushNotificationsLikes,
      pushNotificationsComments:
          pushNotificationsComments ?? this.pushNotificationsComments,
      pushNotificationsFollows:
          pushNotificationsFollows ?? this.pushNotificationsFollows,
      pushNotificationsDirectMessages: pushNotificationsDirectMessages ??
          this.pushNotificationsDirectMessages,
      pushNotificationsITLUpdates:
          pushNotificationsITLUpdates ?? this.pushNotificationsITLUpdates,
      emailNotificationsAppReleases:
          emailNotificationsAppReleases ?? this.emailNotificationsAppReleases,
      emailNotificationsITLUpdates:
          emailNotificationsITLUpdates ?? this.emailNotificationsITLUpdates,
      picker: picker,
      formKey: formKey,
      email: email ?? this.email,
      password: password ?? this.password,
      services: services ?? this.services,
    );
  }
}