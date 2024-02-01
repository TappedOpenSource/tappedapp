import 'package:cached_annotation/cached_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/domains/models/booker_info.dart';
import 'package:intheloopapp/domains/models/email_notifications.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/push_notifications.dart';
import 'package:intheloopapp/domains/models/social_following.dart';
import 'package:intheloopapp/domains/models/username.dart';
import 'package:intheloopapp/domains/models/venue_info.dart';
import 'package:uuid/uuid.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  @JsonSerializable(explicitToJson: true)
  const factory UserModel({
    required String id,
    @OptionalDateTimeConverter() required Option<DateTime> timestamp,
    @UsernameConverter() required Username username,
    @Default('') String email,
    @Default(false) bool unclaimed,
    @Default('') String artistName,
    @Default(None()) Option<String> profilePicture,
    @Default('') String bio,
    @Default([]) List<String> occupations,
    @Default(None()) Option<Location> location,
    @Default(0) int badgesCount,
    @Default(None()) Option<PerformerInfo> performerInfo,
    @Default(None()) Option<BookerInfo> bookerInfo,
    @Default(None()) Option<VenueInfo> venueInfo,
    @Default(SocialFollowing.empty) SocialFollowing socialFollowing,
    @Default(EmailNotifications.empty) EmailNotifications emailNotifications,
    @Default(PushNotifications.empty) PushNotifications pushNotifications,
    @Default(false) bool deleted,
    @Default(None()) Option<String> stripeConnectedAccountId,
    @Default(None()) Option<String> stripeCustomerId,
    @Default(None()) Option<String> latestAppVersion,
  }) = _UserModel;

  factory UserModel.empty() => UserModel(
        id: const Uuid().v4(),
        timestamp: Option.of(DateTime.now()),
        username: Username.fromString('anonymous'),
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final userData = doc.data();
    if (userData == null) {
      throw Exception('user data is null');
    }

    userData['id'] = doc.id;

    return UserModel.fromJson(userData);
  }
}

extension UserHelpers on UserModel {
  Option<double> get overallRating {
    final performerRating = performerInfo.map((e) => e.rating).getOrElse(
          () => const None(),
        );
    final bookerRating = bookerInfo.map((e) => e.rating).getOrElse(
          () => const None(),
        );

    return switch ((performerRating, bookerRating)) {
      (None(), None()) => const None(),
      (Some(:final value), None()) => Option.of(value),
      (None(), Some(:final value)) => Option.of(value),
      (Some(), Some()) => () {
          final overallRating =
              (performerRating.toNullable()! + bookerRating.toNullable()!) / 2;

          return Option.of(overallRating);
        }(),
    };
  }

  String get displayName => artistName.isEmpty ? username.username : artistName;

  bool get isEmpty => this == UserModel.empty();

  bool get isNotEmpty => this != UserModel.empty();

  @Cached(where: _asyncShouldCache)
  Future<bool> hasValidConnectedAccount(PaymentRepository payments) async {
    return stripeConnectedAccountId.fold(
      () => false,
      (stripeAccountId) async {
        final paymentUser = await payments.getAccountById(stripeAccountId);
        return paymentUser.fold(
          () => false,
          (value) => value.payoutsEnabled,
        );
      },
    );
  }
}

Future<bool> _asyncShouldCache(bool candidate) async {
  return candidate;
}
