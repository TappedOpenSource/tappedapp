import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_notifications.g.dart';

@JsonSerializable()
class EmailNotifications {
  const EmailNotifications({
    required this.appReleases,
    required this.tappedUpdates,
    required this.bookingRequests,
  });

  // fromJson
  factory EmailNotifications.fromJson(Map<String, dynamic> json) =>
      _$EmailNotificationsFromJson(json);

  // fromDoc
  factory EmailNotifications.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return EmailNotifications(
      appReleases: doc.getOrElse<bool>('appReleases', true),
      tappedUpdates: doc.getOrElse<bool>('tappedUpdates', true),
      bookingRequests: doc.getOrElse<bool>('bookingRequests', true),
    );
  }

  final bool appReleases;
  final bool tappedUpdates;
  final bool bookingRequests;

  // empty
  static const empty = EmailNotifications(
    appReleases: true,
    tappedUpdates: true,
    bookingRequests: true,
  );

  // toJson
  Map<String, dynamic> toJson() => _$EmailNotificationsToJson(this);

  // copyWith
  EmailNotifications copyWith({
    bool? appReleases,
    bool? tappedUpdates,
    bool? bookingRequests,
  }) {
    return EmailNotifications(
      appReleases: appReleases ?? this.appReleases,
      tappedUpdates: tappedUpdates ?? this.tappedUpdates,
      bookingRequests: bookingRequests ?? this.bookingRequests,
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'appReleases': appReleases,
      'tappedUpdates': tappedUpdates,
      'bookingRequests': bookingRequests,
    };
  }
}

