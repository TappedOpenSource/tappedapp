part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    required this.currentUser,
    required this.visitedUser,
    this.isFollowing = false,
    this.isBlocked = false,
    this.isVerified = false,
    this.latestBookings = const [],
    this.latestReview = const None(),
    this.services = const [],
    this.opportunities = const [],
    this.topTracks = const [],
    this.hasReachedMaxOpportunities = false,
    this.opportunityStatus = OpportunitiesStatus.initial,
    this.isCollapsed = false,
    this.didAddFeedback = false,
    this.place = const None(),
  });

  final bool isFollowing;
  final bool isBlocked;
  final bool isVerified;
  final List<Service> services;
  final List<Opportunity> opportunities;
  final List<SpotifyTrack> topTracks;

  final List<Booking> latestBookings;
  final Option<Review> latestReview;

  final bool hasReachedMaxOpportunities;
  final OpportunitiesStatus opportunityStatus;
  final UserModel visitedUser;
  final UserModel currentUser;
  final Option<PlaceData> place;

  final bool isCollapsed;
  final bool didAddFeedback;

  bool get isCurrentUser => currentUser.id == visitedUser.id;

  @override
  List<Object?> get props => [
        isFollowing,
        isBlocked,
        isVerified,
        latestBookings,
        latestReview,
        hasReachedMaxOpportunities,
        opportunityStatus,
        services,
        opportunities,
        topTracks,
        visitedUser,
        currentUser,
        place,
      ];

  ProfileState copyWith({
    bool? isFollowing,
    bool? isBlocked,
    bool? isVerified,
    List<Booking>? latestBookings,
    Option<Review>? latestReview,
    bool? hasReachedMaxOpportunities,
    OpportunitiesStatus? opportunityStatus,
    List<Service>? services,
    List<Opportunity>? opportunities,
    List<SpotifyTrack>? topTracks,
    UserModel? currentUser,
    UserModel? visitedUser,
    Option<PlaceData>? place,
    bool? isCollapsed,
    bool? didAddFeedback,
  }) {
    return ProfileState(
      isFollowing: isFollowing ?? this.isFollowing,
      isBlocked: isBlocked ?? this.isBlocked,
      isVerified: isVerified ?? this.isVerified,
      latestBookings: latestBookings ?? this.latestBookings,
      latestReview: latestReview ?? this.latestReview,
      hasReachedMaxOpportunities: hasReachedMaxOpportunities ?? this.hasReachedMaxOpportunities,
      opportunityStatus: opportunityStatus ?? this.opportunityStatus,
      services: services ?? this.services,
      opportunities: opportunities ?? this.opportunities,
      topTracks: topTracks ?? this.topTracks,
      currentUser: currentUser ?? this.currentUser,
      visitedUser: visitedUser ?? this.visitedUser,
      place: place ?? this.place,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      didAddFeedback: didAddFeedback ?? this.didAddFeedback,
    );
  }
}

enum OpportunitiesStatus {
  initial,
  success,
  failure,
}
