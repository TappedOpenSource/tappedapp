
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'push_notifications.g.dart';

@JsonSerializable()
class PushNotifications {
  const PushNotifications({
    required this.appReleases,
    required this.tappedUpdates,
    required this.bookingRequests,
    required this.directMessages,
  });

  // fromJson
  factory PushNotifications.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationsFromJson(json);

  // fromDoc
  factory PushNotifications.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PushNotifications(
      appReleases: doc.getOrElse<bool>('appReleases', true),
      tappedUpdates: doc.getOrElse<bool>('tappedUpdates', true),
      bookingRequests: doc.getOrElse<bool>('bookingRequests', true),
      directMessages: doc.getOrElse<bool>('directMessages', true),
    );
  }

  final bool appReleases;
  final bool tappedUpdates;
  final bool bookingRequests;
  final bool directMessages;

  // empty
  static const empty = PushNotifications(
    appReleases: true,
    tappedUpdates: true,
    bookingRequests: true,
    directMessages: true,
  );

  // toJson
  Map<String, dynamic> toJson() => _$PushNotificationsToJson(this);

  // copyWith
  PushNotifications copyWith({
    bool? appReleases,
    bool? tappedUpdates,
    bool? bookingRequests,
    bool? directMessages,j,
  }) {
    return PushNotifications(
      appReleases: appReleases ?? this.appReleases,
      tappedUpdates: tappedUpdates ?? this.tappedUpdates,
      bookingRequests: bookingRequests ?? this.bookingRequests,
      directMessages: directMessages ?? this.directMessages,
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'appReleases': appReleases,
      'tappedUpdates': tappedUpdates,
      'bookingRequests': bookingRequests,
      'directMessages': directMessages,
    };
  }
}
