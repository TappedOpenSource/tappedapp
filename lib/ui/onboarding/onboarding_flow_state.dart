part of 'onboarding_flow_cubit.dart';

class OnboardingFlowState extends Equatable with FormzMixin {
  OnboardingFlowState({
    required this.currentUserId,
    this.artistName = '',
    this.spotifyArtist = const None(),
    this.tiktokHandle = '',
    this.tiktokFollowers = 0,
    this.instagramHandle = '',
    this.instagramFollowers = 0,
    this.eula = false,
    this.photoUrl = const None(),
    this.pickedPhoto = const None(),
    this.status = FormzSubmissionStatus.initial,
    GlobalKey<FormState>? formKey,
  }) {
    this.formKey = formKey ?? GlobalKey<FormState>(debugLabel: 'onboarding');
  }

  final String currentUserId;
  final String artistName;
  final Option<SpotifyArtist> spotifyArtist;
  final String tiktokHandle;
  final int tiktokFollowers;
  final String instagramHandle;
  final int instagramFollowers;
  final bool eula;
  final Option<String> photoUrl;
  final Option<File> pickedPhoto;

  final FormzSubmissionStatus status;
  late final GlobalKey<FormState> formKey;

  @override
  List<Object?> get props => [
        currentUserId,
        spotifyArtist,
        artistName,
        tiktokHandle,
        tiktokFollowers,
        instagramHandle,
        instagramFollowers,
        eula,
        pickedPhoto,
        status,
        formKey,
      ];

  OnboardingFlowState copyWith({
    String? artistName,
    Option<SpotifyArtist>? spotifyArtist,
    String? tiktokHandle,
    int? tiktokFollowers,
    String? instagramHandle,
    int? instagramFollowers,
    bool? eula,
    Option<String>? photoUrl,
    Option<File>? pickedPhoto,
    FormzSubmissionStatus? status,
  }) {
    return OnboardingFlowState(
      currentUserId: currentUserId,
      artistName: artistName ?? this.artistName,
      spotifyArtist: spotifyArtist ?? this.spotifyArtist,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      tiktokFollowers: tiktokFollowers ?? this.tiktokFollowers,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      instagramFollowers: instagramFollowers ?? this.instagramFollowers,
      eula: eula ?? this.eula,
      photoUrl: photoUrl ?? this.photoUrl,
      pickedPhoto: pickedPhoto ?? this.pickedPhoto,
      status: status ?? this.status,
      formKey: formKey,
    );
  }

  @override
  List<FormzInput> get inputs => [];
}
