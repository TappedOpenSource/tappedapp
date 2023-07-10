import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge_model;
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/activity/activity_view.dart';
import 'package:intheloopapp/ui/advanced_search/advanced_search_view.dart';
import 'package:intheloopapp/ui/badge/badge_view.dart';
import 'package:intheloopapp/ui/badge/badges_view.dart';
import 'package:intheloopapp/ui/booking/booking_view.dart';
import 'package:intheloopapp/ui/bookings/user_bookings_feed.dart';
import 'package:intheloopapp/ui/create_booking/booking_confirmation_view.dart';
import 'package:intheloopapp/ui/create_booking/create_booking_view.dart';
import 'package:intheloopapp/ui/create_loop/create_loop_view.dart';
import 'package:intheloopapp/ui/create_service/create_service_view.dart';
import 'package:intheloopapp/ui/follow_relationship/follow_relationship_view.dart';
import 'package:intheloopapp/ui/forms/location_form/location_form_view.dart';
import 'package:intheloopapp/ui/likes/likes_view.dart';
import 'package:intheloopapp/ui/login/forgot_password_view.dart';
import 'package:intheloopapp/ui/login/login_view.dart';
import 'package:intheloopapp/ui/login/signup_view.dart';
import 'package:intheloopapp/ui/loop_feed/loop_feed_view.dart';
import 'package:intheloopapp/ui/loop_view/loop_view.dart';
import 'package:intheloopapp/ui/messaging/channel_view.dart';
import 'package:intheloopapp/ui/messaging/messaging_view.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_view.dart';
import 'package:intheloopapp/ui/opportunities/interested_view.dart';
import 'package:intheloopapp/ui/profile/components/service_selection_view.dart';
import 'package:intheloopapp/ui/profile/profile_view.dart';
import 'package:intheloopapp/ui/reviews/user_reviews_feed.dart';
import 'package:intheloopapp/ui/search/search_view.dart';
import 'package:intheloopapp/ui/settings/settings_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

sealed class TappedRoute {
  TappedRoute({
    required this.view,
    required this.routeName,
  });

  final Widget view;
  final String routeName;
}

final class ProfilePage extends TappedRoute {
  ProfilePage({
    required String userId,
    required Option<UserModel> user,
  }) : super(
          routeName: '/profile/$userId',
          view: ProfileView(
            visitedUserId: userId,
            visitedUser: user,
          ),
        );
}

final class SettingsPage extends TappedRoute {
  SettingsPage()
      : super(
          routeName: '/settings',
          view: const SettingsView(),
        );
}

final class CreateLoopPage extends TappedRoute {
  CreateLoopPage()
      : super(
          routeName: '/create_loop',
          view: const CreateLoopView(),
        );
}

final class LoopPage extends TappedRoute {
  LoopPage({
    required Loop loop,
    required Option<UserModel> loopUser,
  }) : super(
          routeName: '/loop/${loop.id}',
          view: LoopView(
            loop: loop,
            loopUser: loopUser,
          ),
        );
}

final class LoopsPage extends TappedRoute {
  LoopsPage({
    required this.userId,
    required this.database,
  }) : super(
          routeName: '/loops/$userId',
          view: LoopFeedView(
            sourceFunction: (
              String userId, {
              String? lastLoopId,
              int limit = 20,
              bool ignoreCache = false,
            }) async {
              final result = await database.getUserLoops(
                userId,
                limit: limit,
                lastLoopId: lastLoopId,
              );
              return result;
            },
            sourceStream: (
              String userId, {
              int limit = 20,
              bool ignoreCache = false,
            }) async* {
              yield* database.userLoopsObserver(
                userId,
                limit: limit,
              );
            },
            userId: userId,
            feedKey: 'user_loops',
            scrollController: ScrollController(),
            headerSliver: null,
          ),
        );

  final String userId;
  final DatabaseRepository database;
}

final class OpportunitiesPage extends TappedRoute {
  OpportunitiesPage({
    required this.userId,
    required this.database,
  }) : super(
          routeName: '/opportunities/$userId',
          view: LoopFeedView(
            sourceFunction: (
              String userId, {
              String? lastLoopId,
              int limit = 20,
              bool ignoreCache = false,
            }) async {
              final result = await database.getUserOpportunities(
                userId,
                limit: limit,
                lastLoopId: lastLoopId,
              );
              return result;
            },
            sourceStream: (
              String userId, {
              int limit = 20,
              bool ignoreCache = false,
            }) async* {
              yield* database.userOpportunitiesObserver(
                userId,
                limit: limit,
              );
            },
            userId: userId,
            feedKey: 'user_opportunities',
            scrollController: ScrollController(),
            headerSliver: null,
          ),
        );

  final String userId;
  final DatabaseRepository database;
}

final class InterestedPage extends TappedRoute {
  InterestedPage({
    required this.loop,
  }) : super(
          routeName: '/interested/${loop.id}',
          view: InterestedView(
            loop: loop,
          ),
        );

  final Loop loop;
}

final class BadgePage extends TappedRoute {
  BadgePage({
    required badge_model.Badge badge,
  }) : super(
          routeName: '/badge/${badge.id}',
          view: BadgeView(
            badge: badge,
          ),
        );
}

final class BadgesPage extends TappedRoute {
  BadgesPage({
    required this.badges,
  }) : super(
          routeName: '/badges',
          view: BadgesView(badges: badges),
        );

  final List<badge_model.Badge> badges;
}

final class CreateBookingPage extends TappedRoute {
  CreateBookingPage({
    required this.service,
    required this.requesteeStripeConnectedAccountId,
  }) : super(
          routeName: '/create_booking',
          view: CreateBookingView(
            service: service,
            requesteeStripeConnectedAccountId:
                requesteeStripeConnectedAccountId,
          ),
        );

  final Service service;
  final String requesteeStripeConnectedAccountId;
}

final class BookingPage extends TappedRoute {
  BookingPage({
    required this.booking,
  }) : super(
          routeName: '/booking/${booking.id}',
          view: BookingView(booking: booking),
        );

  final Booking booking;
}

final class BookingConfirmationPage extends TappedRoute {
  BookingConfirmationPage({
    required this.booking,
  }) : super(
          routeName: '/booking_confirmation/${booking.id}',
          view: BookingConfirmationView(booking: booking),
        );

  final Booking booking;
}

final class BookingsPage extends TappedRoute {
  BookingsPage({
    required this.userId,
  }) : super(
          routeName: '/bookings/$userId',
          view: UserBookingsFeed(
            userId: userId,
          ),
        );

  final String userId;
}

final class SearchPage extends TappedRoute {
  SearchPage()
      : super(
          routeName: '/search',
          view: SearchView(),
        );
}

final class AdvancedSearchPage extends TappedRoute {
  AdvancedSearchPage()
      : super(
          routeName: '/advanced_search',
          view: const AdvancedSearchView(),
        );
}

final class ServiceSelectionPage extends TappedRoute {
  ServiceSelectionPage({
    required this.userId,
    required this.requesteeStripeConnectedAccountId,
  }) : super(
          routeName: '/service_selection',
          view: ServiceSelectionView(
            userId: userId,
            requesteeStripeConnectedAccountId:
                requesteeStripeConnectedAccountId,
          ),
        );

  final String userId;
  final String requesteeStripeConnectedAccountId;
}

final class CreateServicePage extends TappedRoute {
  CreateServicePage({
    required this.onCreated,
  }) : super(
          routeName: '/create_service',
          view: CreateServiceView(
            onCreated: onCreated,
          ),
        );

  final void Function(Service) onCreated;
}

final class LocationFormPage extends TappedRoute {
  LocationFormPage({
    required this.initialPlace,
    required this.onSelected,
  }) : super(
          routeName: '/location_form',
          view: LocationFormView(
            initialPlace: initialPlace,
            onSelected: onSelected,
          ),
        );

  final Place? initialPlace;
  final void Function(Place?, String) onSelected;
}

final class LikesPage extends TappedRoute {
  LikesPage({
    required this.loop,
  }) : super(
          routeName: '/likes/${loop.id}',
          view: LikesView(loop: loop),
        );

  final Loop loop;
}

final class ReviewsPage extends TappedRoute {
  ReviewsPage({
    required this.userId,
  }) : super(
          routeName: '/reviews/$userId',
          view: UserReviewsFeed(
            userId: userId,
          ),
        );

  final String userId;
}

final class ActivitiesPage extends TappedRoute {
  ActivitiesPage()
      : super(
          routeName: '/activities',
          view: const ActivityView(),
        );
}

final class LoginPage extends TappedRoute {
  LoginPage()
      : super(
          routeName: '/login',
          view: const LoginView(),
        );
}

final class ForgotPasswordPage extends TappedRoute {
  ForgotPasswordPage()
      : super(
          routeName: '/forgot_password',
          view: const ForgotPasswordView(),
        );
}

final class SignUpPage extends TappedRoute {
  SignUpPage()
      : super(
          routeName: '/sign_up',
          view: const SignUpView(),
        );
}

final class OnboardingPage extends TappedRoute {
  OnboardingPage()
      : super(
          routeName: '/onboarding',
          view: const OnboardingView(),
        );
}

final class StreamChannelPage extends TappedRoute {
  StreamChannelPage({
    required this.channel,
  }) : super(
          routeName: '/stream_channel/${channel.id}',
          view: StreamChannel(
            channel: channel,
            child: const ChannelView(),
          ),
        );

  final Channel channel;
}

final class MessagingChannelListPage extends TappedRoute {
  MessagingChannelListPage()
      : super(
          routeName: '/messaging_channel_list',
          view: const MessagingChannelListView(),
        );
}

final class FollowRelationshipPage extends TappedRoute {
  FollowRelationshipPage({
    required this.userId,
    required this.index,
  }) : super(
          routeName: '/followers/$userId',
          view: FollowRelationshipView(
            visitedUserId: userId,
            initialIndex: index,
          ),
        );

  final String userId;
  final int index;
}
