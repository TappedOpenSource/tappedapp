import 'package:feedback/feedback.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/review.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

abstract class DatabaseRepository {
  Future<String> publishLatestAppVersion(String currentUserId);

  // User related stuff
  Future<bool> userEmailExists(String email);
  Future<void> createUser(UserModel user);
  Future<Option<UserModel>> getUserByUsername(String? username);
  Future<Option<UserModel>> getUserById(String userId);
  Future<List<UserModel>> searchUsersByLocation({
    required double lat,
    required double lng,
    int radiusInMeters = 50 * 1000, // 50km
    int limit = 100,
    String? lastUserId,
  });
  Future<void> updateUserData(UserModel user);
  Future<bool> checkUsernameAvailability(String username, String userid);

  Future<List<UserModel>> getRichmondVenues();
  Future<List<UserModel>> getDCVenues();
  Future<List<UserModel>> getNovaVenues();
  Future<List<UserModel>> getMarylandVenues();
  Future<List<UserModel>> getBookingLeaders();
  Future<List<UserModel>> getBookerLeaders();
  Future<List<Opportunity>> getFeaturedOpportunities();

  // Activity related stuff
  Future<List<Activity>> getActivities(
    String userId, {
    int limit = 100,
    String? lastActivityId,
  });
  Stream<Activity> activitiesObserver(
    String userId, {
    int limit = 100,
  });
  Future<void> addActivity({
    required String currentUserId,
    required String visitedUserId,
    required ActivityType type,
  });
  Future<void> markActivityAsRead(Activity activity);

  // Badge related stuff
  Future<bool> isVerified(String userId);
  Stream<Badge> userBadgesObserver(
    String userId, {
    int limit = 100,
  });
  Future<List<Badge>> getUserBadges(
    String userId, {
    int limit = 100,
    String? lastBadgeId,
  });

  // Booking related stuff
  Future<void> createBooking(
    Booking booking,
  );
  Future<Option<Booking>> getBookingById(
    String bookRequestId,
  );
  Future<List<Booking>> getBookingsByRequesterRequestee(
    String requesterId,
    String requesteeId, {
    int limit = 20,
    String? lastBookingRequestId,
    BookingStatus? status,
  });
  Future<List<Booking>> getBookingsByRequester(
    String userId, {
    int limit = 20,
    String? lastBookingRequestId,
    BookingStatus? status,
  });
  Stream<Booking> getBookingsByRequesterObserver(
    String userId, {
    int limit = 20,
    BookingStatus? status,
  });
  Future<List<Booking>> getBookingsByRequestee(
    String userId, {
    int limit = 20,
    String? lastBookingRequestId,
    BookingStatus? status,
  });
  Stream<Booking> getBookingsByRequesteeObserver(
    String userId, {
    int limit = 20,
    BookingStatus? status,
  });
  Future<void> updateBooking(Booking booking);

  // Service related stuff
  Future<void> createService(Service service);
  Future<void> updateService(Service service);
  Future<Option<Service>> getServiceById(String userId, String serviceId);
  Future<List<Service>> getUserServices(String userId);
  Future<void> deleteService(String userId, String serviceId);

  // Opportunity related stuff
  Future<Option<Opportunity>> getOpportunityById(String opportunityId);
  Future<List<Opportunity>> getOpportunities({
    int limit = 20,
    String? lastOpportunityId,
  });
  Future<List<Opportunity>> getOpportunitiesByUserId(String userId, {
    int limit = 20,
    String? lastOpportunityId,
  });
  Future<List<Opportunity>> getOpportunityFeedByUserId(
    String userId, {
    int limit = 20,
    String? lastOpportunityId,
  });
  Future<bool> isUserAppliedForOpportunity({
    required String opportunityId,
    required String userId,
  });
  Future<List<UserModel>> getInterestedUsers(Opportunity opportunity);
  Future<void> applyForOpportunity({
    required Opportunity opportunity,
    required String userId,
    required String userComment,
  });
  Future<void> dislikeOpportunity({
    required Opportunity opportunity,
    required String userId,
  });
  Future<int> getUserOpportunityQuota(String userId);
  Stream<int> getUserOpportunityQuotaObserver(String userId);
  Future<void> decrementUserOpportunityQuota(String userId);

  Future<void> createOpportunity(Opportunity opportunity);
  Future<void> copyOpportunityToFeeds(Opportunity opportunity);

  Future<void> deleteOpportunity(String opportunityId);

  // blocking
  Future<void> blockUser({
    required String currentUserId,
    required String blockedUserId,
  });
  Future<void> unblockUser({
    required String currentUserId,
    required String blockedUserId,
  });
  Future<bool> isBlocked({
    required String currentUserId,
    required String blockedUserId,
  });
  Future<void> reportUser({
    required UserModel reported,
    required UserModel reporter,
  });

  // Performer Review related stuff
  Future<void> createPerformerReview(
    PerformerReview review,
  );
  Future<Option<PerformerReview>> getPerformerReviewById({
    required String revieweeId,
    required String reviewId,
  });
  Future<List<PerformerReview>> getPerformerReviewsByPerformerId(
    String performerId, {
    int limit = 20,
    String? lastReviewId,
  });
  Stream<PerformerReview> getPerformerReviewsByPerformerIdObserver(
    String performerId, {
    int limit = 20,
  });

  // Booker Review related stuff
  Future<void> createBookerReview(
    BookerReview review,
  );
  Future<Option<BookerReview>> getBookerReviewById({
    required String revieweeId,
    required String reviewId,
  });
  Future<List<BookerReview>> getBookerReviewsByBookerId(
    String bookerId, {
    int limit = 20,
    String? lastReviewId,
  });
  Stream<BookerReview> getBookerReviewsByBookerIdObserver(
    String bookerId, {
    int limit = 20,
  });
  Future<void> joinPremiumWaitlist(String userId);
  Future<bool> isOnPremiumWailist(String userId);

  Future<void> sendFeedback(String userId, UserFeedback feedback, String imageUrl);
}
