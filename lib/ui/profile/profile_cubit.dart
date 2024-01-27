import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge;
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/review.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.database,
    required this.places,
    required this.currentUser,
    required this.visitedUser,
  }) : super(
          ProfileState(
            currentUser: currentUser,
            visitedUser: visitedUser,
          ),
        );
  final DatabaseRepository database;
  final PlacesRepository places;
  final UserModel currentUser;
  final UserModel visitedUser;
  StreamSubscription<badge.Badge>? badgeListener;

  bool onNotification(
    ScrollController scrollController,
    double expandedBarHeight,
    double collapsedBarHeight,
  ) {
    emit(
      state.copyWith(
        isCollapsed: scrollController.hasClients &&
            scrollController.offset > (expandedBarHeight - collapsedBarHeight),
      ),
    );

    /// When the app bar is collapsed and the feedback
    /// hasn't been added previously will invoke
    /// the `mediumImpact()` method, otherwise will
    /// reset the didAddFeedback value.
    ///
    if (state.isCollapsed && !state.didAddFeedback) {
      HapticFeedback.mediumImpact();
      emit(state.copyWith(didAddFeedback: true));
    } else if (!state.isCollapsed) {
      emit(state.copyWith(didAddFeedback: false));
    }
    return false;
  }

  Future<void> refetchVisitedUser({UserModel? newUserData}) async {
    try {
      logger.debug(
        'refetchVisitedUser ${state.visitedUser} : ${newUserData ?? "null"}',
      );
      if (newUserData == null) {
        final refreshedVisitedUser =
            await database.getUserById(state.visitedUser.id);
        emit(state.copyWith(visitedUser: refreshedVisitedUser.toNullable()));
      } else {
        emit(state.copyWith(visitedUser: newUserData));
      }
    } catch (e, s) {
      logger.error(
        'refetchVisitedUser error',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> getLatestBooking() async {
    final trace = logger.createTrace('getLatestBooking');
    await trace.start();
    try {
      final bookingsRequestee = await database.getBookingsByRequestee(
        visitedUser.id,
        limit: 1,
        status: BookingStatus.confirmed,
      );
      final bookingsRequester = await database.getBookingsByRequester(
        visitedUser.id,
        limit: 1,
        status: BookingStatus.confirmed,
      );

      final latestRequesteeBooking = bookingsRequestee.isNotEmpty
          ? Option.of(bookingsRequestee.first)
          : const None();

      final latestRequesterBooking = bookingsRequester.isNotEmpty
          ? Option.of(bookingsRequester.first)
          : const None();

      final _ = switch ((latestRequesteeBooking, latestRequesterBooking)) {
        (None(), None()) => emit(state.copyWith(latestBooking: const None())),
        (Some(:final value), None()) =>
          emit(state.copyWith(latestBooking: Option.of(value))),
        (None(), Some(:final value)) => emit(
            state.copyWith(
              latestBooking: Option.of(value),
            ),
          ),
        (Some(), Some()) => () {
            final latest = _getLatestBooking(
              latestRequesteeBooking.toNullable()!,
              latestRequesterBooking.toNullable()!,
            );
            emit(state.copyWith(latestBooking: Option.of(latest)));
          }(),
      };
    } catch (e, s) {
      logger.error(
        'fetchMoreBookings error',
        error: e,
        stackTrace: s,
      );
      // emit(state.copyWith(bookingsStatus: BookingsStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  Booking _getLatestBooking(Booking b1, Booking b2) {
    return b1.startTime.isAfter(b2.startTime) ? b1 : b2;
  }

  Future<void> getLatestReview() async {
    final trace = logger.createTrace('getLatestReview');
    await trace.start();
    try {
      final performerReviews =
          await database.getPerformerReviewsByPerformerId(
        visitedUser.id,
        limit: 1,
      );
      final bookerReviews = await database.getBookerReviewsByBookerId(
        visitedUser.id,
        limit: 1,
      );

      final latestPerformerReview = performerReviews.isNotEmpty
          ? Option.of(performerReviews.first)
          : const None();

      final latestBookerReview = bookerReviews.isNotEmpty
          ? Option.of(bookerReviews.first)
          : const None();

      final _ = switch ((latestPerformerReview, latestBookerReview)) {
        (None(), None()) => emit(state.copyWith(latestReview: const None())),
        (Some(:final value), None()) =>
          emit(state.copyWith(latestReview: Option.of(value))),
        (None(), Some(:final value)) => emit(
            state.copyWith(
              latestReview: Option.of(value),
            ),
          ),
        (Some(), Some()) => () {
            final latest = _getLatestReview(
              latestPerformerReview.toNullable()!,
              latestBookerReview.toNullable()!,
            );
            emit(state.copyWith(latestReview: Option.of(latest)));
          }(),
      };
    } catch (e, s) {
      logger.error(
        'fetchMoreReviews error',
        error: e,
        stackTrace: s,
      );
      // emit(state.copyWith(reviewsStatus: ReviewssStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  Review _getLatestReview(Review r1, Review r2) {
    return r1.timestamp.isAfter(r2.timestamp) ? r1 : r2;
  }

  Future<void> initServices() async {
    final services = await database.getUserServices(visitedUser.id);
    emit(
      state.copyWith(
        services: services
          ..sort(
            (a, b) => a.rate.compareTo(b.rate),
          ),
      ),
    );
  }

  Future<void> initOpportunities() async {
    try {
      final opportunities = await database.getOpportunitiesByUserId(
        visitedUser.id,
        limit: 5,
      );

      logger.debug('initOpportunities ${opportunities.length}');

      emit(
        state.copyWith(
          opportunities:
              opportunities.where((element) => !element.deleted).toList(),
        ),
      );
    } catch (e, s) {
      logger.error(
        'initOpportunities error',
        error: e,
        stackTrace: s,
      );
    }
  }

  void onServiceCreated(Service service) {
    emit(
      state.copyWith(
        services: List.of(state.services)
          ..insert(0, service)
          ..sort(
            (a, b) => a.rate.compareTo(b.rate),
          ),
      ),
    );
  }

  void onServiceEdited(Service service) {
    emit(
      state.copyWith(
        services: List.of(state.services)
          ..removeWhere((s) => s.id == service.id)
          ..insert(0, service)
          ..sort(
            (a, b) => a.rate.compareTo(b.rate),
          ),
      ),
    );
  }

  Future<void> removeService(Service service) async {
    try {
      await database.deleteService(
        currentUser.id,
        service.id,
      );
      emit(
        state.copyWith(
          services: List.of(state.services)..remove(service),
        ),
      );
    } catch (e, s) {
      logger.error(
        'Error removing service',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> initBadges({bool clearBadges = true}) async {
    final trace = logger.createTrace('initBadges');
    await trace.start();
    try {
      logger.debug(
        'initBadges ${state.visitedUser}',
      );
      await badgeListener?.cancel();
      if (clearBadges) {
        emit(
          state.copyWith(
            badgeStatus: BadgesStatus.initial,
            userBadges: [],
            hasReachedMaxBadges: false,
          ),
        );
      }

      final badgesAvailable =
          (await database.getUserBadges(visitedUser.id, limit: 1))
              .isNotEmpty;
      if (!badgesAvailable) {
        emit(state.copyWith(badgeStatus: BadgesStatus.success));
      }

      badgeListener = database
          .userBadgesObserver(visitedUser.id)
          .listen((badge.Badge event) {
        logger.debug('badge { ${event.id} : ${event.name} }');
        try {
          emit(
            state.copyWith(
              badgeStatus: BadgesStatus.success,
              userBadges: List.of(state.userBadges)..add(event),
              hasReachedMaxBadges: state.userBadges.length < 10,
            ),
          );
        } catch (e, s) {
          logger.error('initBadges error', error: e, stackTrace: s);
        }
      });
    } catch (e, s) {
      logger.error('initBadges error', error: e, stackTrace: s);
    } finally {
      await trace.stop();
    }
  }

  Future<void> initPlace() async {
    final trace = logger.createTrace('initPlace');
    await trace.start();
    try {
      logger.debug('initPlace ${state.visitedUser}');
      final place = await switch (visitedUser.location) {
        None() => Future.value(null),
        Some(:final value) => (() async {
          return await places.getPlaceById(value.placeId);
        })(),
      };
      emit(state.copyWith(place: place));
    } catch (e, s) {
      logger.error('initPlace error', error: e, stackTrace: s);
    } finally {
      await trace.stop();
    }
  }

  Future<void> fetchMoreOpportunities() async {
    if (state.hasReachedMaxOpportunities) return;

    final trace = logger.createTrace('fetchMoreOpportunities');
    await trace.start();
    try {
      if (state.opportunityStatus == OpportunitiesStatus.initial) {
        await initOpportunities();
      }

      final opportunities = await database.getOpportunitiesByUserId(
        visitedUser.id,
        limit: 5,
        lastOpportunityId: state.opportunities.last.id,
      );
      opportunities.isEmpty
          ? emit(state.copyWith(hasReachedMaxOpportunities: true))
          : emit(
              state.copyWith(
                opportunityStatus: OpportunitiesStatus.success,
                opportunities: List.of(state.opportunities)..addAll(opportunities),
                hasReachedMaxOpportunities: false,
              ),
            );
    } catch (e, s) {
      logger.error(
        'fetchMoreOpportunities error',
        error: e,
        stackTrace: s,
      );
      emit(state.copyWith(opportunityStatus: OpportunitiesStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  Future<void> fetchMoreBadges() async {
    if (state.hasReachedMaxBadges) return;

    final trace = logger.createTrace('fetchMoreBadges');
    await trace.start();
    try {
      if (state.badgeStatus == BadgesStatus.initial) {
        await initBadges();
      }

      final badges = await database.getUserBadges(
        visitedUser.id,
        limit: 10,
        lastBadgeId: state.userBadges.last.id,
      );
      badges.isEmpty
          ? emit(state.copyWith(hasReachedMaxBadges: true))
          : emit(
              state.copyWith(
                badgeStatus: BadgesStatus.success,
                userBadges: List.of(state.userBadges)..addAll(badges),
                hasReachedMaxBadges: false,
              ),
            );
    } catch (e, s) {
      logger.error(
        'fetchMoreBadges error',
        error: e,
        stackTrace: s,
      );
      // emit(state.copyWith(badgeStatus: BadgesStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  Future<void> block() async {
    try {
      logger.debug('block ${state.visitedUser.id}');
      emit(state.copyWith(isBlocked: true));
      await database.blockUser(
        currentUserId: state.currentUser.id,
        blockedUserId: state.visitedUser.id,
      );
    } catch (e, s) {
      logger.error('block error', error: e, stackTrace: s);
    }
  }

  Future<void> unblock() async {
    try {
      logger.debug('unblock ${state.visitedUser.id}');
      emit(state.copyWith(isBlocked: false));
      await database.unblockUser(
        currentUserId: state.currentUser.id,
        blockedUserId: state.visitedUser.id,
      );
    } catch (e, s) {
      logger.error('unblock error', error: e, stackTrace: s);
    }
  }

  Future<void> loadIsBlocked() async {
    try {
      final isBlocked = await database.isBlocked(
        currentUserId: state.currentUser.id,
        blockedUserId: state.visitedUser.id,
      );

      emit(
        state.copyWith(
          isBlocked: isBlocked,
        ),
      );
    } catch (e, s) {
      logger.error('loadIsBlocked error', error: e, stackTrace: s);
    }
  }

  Future<void> loadIsVerified(String visitedUserId) async {
    try {
      final isVerified = await database.isVerified(visitedUserId);

      emit(
        state.copyWith(
          isVerified: isVerified,
        ),
      );
    } catch (e, s) {
      logger.error('loadIsVerified error', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> close() async {
    await badgeListener?.cancel();
    await super.close();
  }
}
