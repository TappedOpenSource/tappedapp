part of 'onboarding_flow_cubit.dart';

class OnboardingFlowState extends Equatable with FormzMixin {
  OnboardingFlowState({
    required this.currentUserId,
    this.username = const UsernameInput.pure(),
    this.spotifyUrl = const None(),
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
  final UsernameInput username;
  final Option<String> spotifyUrl;
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
        username,
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
    UsernameInput? username,
    Option<String>? spotifyUrl,
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
      username: username ?? this.username,
      spotifyUrl: spotifyUrl ?? this.spotifyUrl,
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
  List<FormzInput<String, Object>> get inputs => [
    username,
  ];
}
