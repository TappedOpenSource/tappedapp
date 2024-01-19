part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  ProfileState({
    required this.currentUser,
    required this.visitedUser,
    this.isFollowing = false,
    this.isBlocked = false,
    this.isVerified = false,
    this.latestBooking = const None(),
    this.latestReview = const None(),
    this.userBadges = const [],
    this.services = const [],
    this.opportunities = const [],
    this.hasReachedMaxBadges = false,
    this.hasReachedMaxOpportunities = false,
    this.badgeStatus = BadgesStatus.initial,
    this.opportunityStatus = OpportunitiesStatus.initial,
    this.isCollapsed = false,
    this.didAddFeedback = false,
    this.place,
  });

  final bool isFollowing;
  final bool isBlocked;
  final bool isVerified;
  final List<badge.Badge> userBadges;
  final List<Service> services;
  final List<Opportunity> opportunities;

  final Option<Booking> latestBooking;
  final Option<Review> latestReview;

  final bool hasReachedMaxBadges;
  final BadgesStatus badgeStatus;
  final bool hasReachedMaxOpportunities;
  final OpportunitiesStatus opportunityStatus;
  final UserModel visitedUser;
  final UserModel currentUser;
  final PlaceData? place;

  final bool isCollapsed;
  final bool didAddFeedback;

  @override
  List<Object?> get props => [
        isFollowing,
        isBlocked,
        isVerified,
        latestBooking,
        latestReview,
        userBadges,
        hasReachedMaxBadges,
        badgeStatus,
        hasReachedMaxOpportunities,
        opportunityStatus,
        services,
        opportunities,
        visitedUser,
        currentUser,
        place,
      ];

  ProfileState copyWith({
    bool? isFollowing,
    bool? isBlocked,
    bool? isVerified,
    Option<Booking>? latestBooking,
    Option<Review>? latestReview,
    List<badge.Badge>? userBadges,
    bool? hasReachedMaxBadges,
    BadgesStatus? badgeStatus,
    bool? hasReachedMaxOpportunities,
    OpportunitiesStatus? opportunityStatus,
    List<Service>? services,
    List<Opportunity>? opportunities,
    UserModel? currentUser,
    UserModel? visitedUser,
    PlaceData? place,
    bool? isCollapsed,
    bool? didAddFeedback,
  }) {
    return ProfileState(
      isFollowing: isFollowing ?? this.isFollowing,
      isBlocked: isBlocked ?? this.isBlocked,
      isVerified: isVerified ?? this.isVerified,
      latestBooking: latestBooking ?? this.latestBooking,
      latestReview: latestReview ?? this.latestReview,
      userBadges: userBadges ?? this.userBadges,
      hasReachedMaxBadges: hasReachedMaxBadges ?? this.hasReachedMaxBadges,
      badgeStatus: badgeStatus ?? this.badgeStatus,
      hasReachedMaxOpportunities: hasReachedMaxOpportunities ?? this.hasReachedMaxOpportunities,
      opportunityStatus: opportunityStatus ?? this.opportunityStatus,
      services: services ?? this.services,
      opportunities: opportunities ?? this.opportunities,
      currentUser: currentUser ?? this.currentUser,
      visitedUser: visitedUser ?? this.visitedUser,
      place: place ?? this.place,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      didAddFeedback: didAddFeedback ?? this.didAddFeedback,
    );
  }
}

enum BadgesStatus {
  initial,
  success,
  failure,
}

enum OpportunitiesStatus {
  initial,
  success,
  failure,
}
