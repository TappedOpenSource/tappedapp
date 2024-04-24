
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge_model;
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/activity/activity_view.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_view.dart';
import 'package:intheloopapp/ui/admin/admin_view.dart';
import 'package:intheloopapp/ui/advanced_search/advanced_search_view.dart';
import 'package:intheloopapp/ui/badge/badge_view.dart';
import 'package:intheloopapp/ui/badge/badges_view.dart';
import 'package:intheloopapp/ui/booking/booking_view.dart';
import 'package:intheloopapp/ui/booking_history/booking_history_view.dart';
import 'package:intheloopapp/ui/bookings/user_bookings_feed.dart';
import 'package:intheloopapp/ui/create_booking/booking_confirmation_view.dart';
import 'package:intheloopapp/ui/create_booking/create_booking_view.dart';
import 'package:intheloopapp/ui/create_service/create_service_view.dart';
import 'package:intheloopapp/ui/discover/components/search_view.dart';
import 'package:intheloopapp/ui/discover/discover_view.dart';
import 'package:intheloopapp/ui/forms/location_form/location_form_view.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_view.dart';
import 'package:intheloopapp/ui/login/forgot_password_view.dart';
import 'package:intheloopapp/ui/login/login_view.dart';
import 'package:intheloopapp/ui/login/signup_view.dart';
import 'package:intheloopapp/ui/messaging/channel_view.dart';
import 'package:intheloopapp/ui/messaging/messaging_view.dart';
import 'package:intheloopapp/ui/messaging/video_call_view.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_view.dart';
import 'package:intheloopapp/ui/opportunities/interested_users_view.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/opportunity_view.dart';
import 'package:intheloopapp/ui/paywall/paywall_view.dart';
import 'package:intheloopapp/ui/profile/components/service_selection_view.dart';
import 'package:intheloopapp/ui/profile/profile_view.dart';
import 'package:intheloopapp/ui/request_to_perform/request_to_perform_confirmation_view.dart';
import 'package:intheloopapp/ui/request_to_perform/request_to_perform_view.dart';
import 'package:intheloopapp/ui/reviews/user_reviews_feed.dart';
import 'package:intheloopapp/ui/services/service_view.dart';
import 'package:intheloopapp/ui/settings/settings_view.dart';
import 'package:intheloopapp/ui/share_profile/share_profile_view.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:photo_view/photo_view.dart';
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
    HeroImage? heroImage,
    String? titleHeroTag,
  }) : super(
          routeName: '/$userId',
          view: ProfileView(
            visitedUserId: userId,
            visitedUser: user,
            heroImage: heroImage,
            titleHeroTag: titleHeroTag,
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
    required this.requesteeId,
    required this.service,
    required this.requesteeStripeConnectedAccountId,
  }) : super(
          routeName: '/create_booking',
          view: CreateBookingView(
            service: service,
            requesteeId: requesteeId,
            requesteeStripeConnectedAccountId:
                requesteeStripeConnectedAccountId,
          ),
        );

  final String requesteeId;
  final Option<Service> service;
  final Option<String> requesteeStripeConnectedAccountId;
}

final class BookingPage extends TappedRoute {
  BookingPage({
    required this.booking,
    this.flierImage = const None(),
  }) : super(
          routeName: '/booking/${booking.id}',
          view: BookingView(
            booking: booking,
            flierImage: flierImage,
          ),
        );

  final Booking booking;
  final Option<HeroImage> flierImage;
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

final class DiscoveryPage extends TappedRoute {
  DiscoveryPage()
      : super(
          routeName: '/discovery',
          view: const DiscoverView(),
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
  final Option<String> requesteeStripeConnectedAccountId;
}

final class CreateServicePage extends TappedRoute {
  CreateServicePage({
    required this.onSubmit,
    required this.service,
  }) : super(
          routeName: '/create_service',
          view: CreateServiceView(
            onSubmit: onSubmit,
            service: service,
          ),
        );

  final void Function(Service) onSubmit;
  final Option<Service> service;
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

  final Option<PlaceData> initialPlace;
  final void Function(Option<PlaceData>, String) onSelected;
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

final class ServicePage extends TappedRoute {
  ServicePage({
    required this.service,
    required this.serviceUser,
  }) : super(
          routeName: '/service/${service.id}',
          view: ServiceView(
            service: service,
            serviceUser: serviceUser,
          ),
        );

  final Service service;
  final Option<UserModel> serviceUser;
}

final class VideoCallPage extends TappedRoute {
  VideoCallPage(// {
      // required this.call,
      // }
      )
      : super(
          // routeName: '/video_call/${call.id}',
          routeName: '/video_call',
          view: const VideoCallView(
              // call: call,
              ),
        );

// final Call call;
}

final class InterestedUsersPage extends TappedRoute {
  InterestedUsersPage({
    required this.opportunity,
  }) : super(
          routeName: '/interested_users/${opportunity.id}',
          view: InterestedUsersView(
            opportunity: opportunity,
          ),
        );

  final Opportunity opportunity;
}

final class OpportunityPage extends TappedRoute {
  OpportunityPage({
    required this.opportunityId,
    required this.opportunity,
    this.onApply,
    this.onDislike,
    this.onDismiss,
    this.heroImage,
    this.titleHeroTag,
    this.showDislikeButton = true,
    this.showAppBar = true,
  }) : super(
          routeName: '/opportunity/$opportunityId',
          view: OpportunityView(
            opportunityId: opportunityId,
            opportunity: opportunity,
            heroImage: heroImage,
            titleHeroTag: titleHeroTag,
            showDislikeButton: showDislikeButton,
            showAppBar: showAppBar,
            onApply: onApply,
            onDislike: onDislike,
            onDismiss: onDismiss,
          ),
        );

  final String opportunityId;
  final Option<Opportunity> opportunity;
  final bool showDislikeButton;
  final bool showAppBar;
  final String? titleHeroTag;
  final HeroImage? heroImage;
  final void Function()? onApply;
  final void Function()? onDislike;
  final void Function()? onDismiss;
}

final class PaywallPage extends TappedRoute {
  PaywallPage()
      : super(
          routeName: '/paywall',
          view: const PaywallView(),
        );
}

final class AdminPage extends TappedRoute {
  AdminPage()
      : super(
          routeName: '/admin',
          view: const AdminView(),
        );
}

final class SearchPage extends TappedRoute {
  SearchPage({
    this.searchFocusNode,
  }) : super(
          routeName: '/search',
          view: SearchView(
            focusNode: searchFocusNode,
          ),
        );

  final FocusNode? searchFocusNode;
}

final class GigSearchPage extends TappedRoute {
  GigSearchPage()
      : super(
          routeName: '/gig_search',
          view: const GigSearchView(),
        );
}

final class RequestToPerformPage extends TappedRoute {
  RequestToPerformPage({
    required this.venues,
    required this.collaborators,
  }) : super(
          routeName: '/request_to_perform',
          view: RequestToPerformView(
            venues: venues,
            collaborators: collaborators,
          ),
        );

  final List<UserModel> venues;
  final List<UserModel> collaborators;
}

final class RequestToPerformConfirmationPage extends TappedRoute {
  RequestToPerformConfirmationPage()
      : super(
          routeName: '/request_to_perform_confirmation',
          view: const RequestToPerformConfirmationView(),
        );
}

final class AddPastBookingPage extends TappedRoute {
  AddPastBookingPage()
      : super(
          routeName: '/add_past_booking',
          view: const AddPastBookingView(),
        );
}

final class ImagePage extends TappedRoute {
  ImagePage({
    required this.heroImage,
  }) : super(
          routeName: '/image',
          view: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  // actions: [
                  //   IconButton(
                  //     onPressed: () {
                  //       _saveImage(
                  //         context,
                  //         heroImage,
                  //       );
                  //     },
                  //     icon: const Icon(Icons.download_rounded),
                  //   ),
                  // ],
                ),
                body: PhotoView(
                  imageProvider: heroImage.imageProvider,
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: heroImage.heroTag),
                ),
              );
            },
          ),
        );

  // static Future<void> _writeToFile(ByteData data, String path) {
  //   final buffer = data.buffer;
  //   return File(path).writeAsBytes(
  //     buffer.asUint8List(
  //       data.offsetInBytes,
  //       data.lengthInBytes,
  //     ),
  //   );
  // }
  //
  // static Future<void> _saveImage(
  //   BuildContext context,
  //   HeroImage heroImage,
  // ) async {
  //   String? message;
  //   final scaffoldMessenger = ScaffoldMessenger.of(context);
  //   final config = createLocalImageConfiguration(context);
  //
  //   await EasyLoading.show();
  //   try {
  //     final imageBytes = await heroImage.imageProvider.getBytes(
  //       imageConfig: config,
  //     );
  //     if (imageBytes == null) {
  //       throw Exception('Failed to get image bytes');
  //     }
  //
  //     // save bytes to path
  //     final uuid = const Uuid().v4();
  //     final mime = lookupMimeType('', headerBytes: imageBytes) ?? 'image/png';
  //     final extension = extensionFromMime(mime);
  //     final tempDir = await getTemporaryDirectory();
  //     final tempPath = tempDir.path;
  //     final filePath = '$tempPath/$uuid.$extension';
  //
  //     await _writeToFile(imageBytes.buffer.asByteData(), filePath);
  //
  //     final result = await GallerySaver.saveImage(
  //       filePath,
  //       // imageBytes,
  //       // quality: 100,
  //     );
  //     message = 'Image saved to $result';
  //   } catch (e, s) {
  //     logger.error(
  //       'Failed to save image',
  //       error: e,
  //       stackTrace: s,
  //     );
  //     message = 'Failed to save image: $e';
  //   } finally {
  //     await EasyLoading.dismiss();
  //   }
  //
  //   scaffoldMessenger.showSnackBar(
  //     SnackBar(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       content: Text(
  //         message,
  //       ),
  //     ),
  //   );
  // }
  //
  final HeroImage heroImage;
}

final class ShareProfilePage extends TappedRoute {
  ShareProfilePage({
    required this.userId,
    required this.user,
  }) : super(
          routeName: '/share_profile/$userId',
          view: ShareProfileView(
            userId: userId,
            user: user,
          ),
        );

  final String userId;
  final Option<UserModel> user;
}

final class BookingHistoryPage extends TappedRoute {
  BookingHistoryPage({
    required this.user,
  }) : super(
          routeName: '/history/${user.id}',
          view: BookingHistoryView(
            user: user,
          ),
        );

  final UserModel user;
}
