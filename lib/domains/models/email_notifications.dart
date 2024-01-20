import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_notifications.g.dart';

@JsonSerializable()
class EmailNotifications extends Equatable {
  const EmailNotifications({
    required this.appReleases,
    required this.tappedUpdates,
    required this.bookingRequests,
  });

  final bool appReleases;
  final bool tappedUpdates;
  final bool bookingRequests;

  @override
  List<Object?> get props => [
    appReleases,
    tappedUpdates,
    bookingRequests,
  ];

  // empty
  factory EmailNotifications.empty() => const EmailNotifications(
    appReleases: true,
    tappedUpdates: true,
    bookingRequests: true,
  );

  // fromJson
  factory EmailNotifications.fromJson(Map<String, dynamic> json) =>
      _$EmailNotificationsFromJson(json);

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

  // fromDoc
  factory EmailNotifications.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return EmailNotifications(
      appReleases: doc.getOrElse<bool>('appReleases', true),
      tappedUpdates: doc.getOrElse<bool>('tappedUpdates', true),
      bookingRequests: doc.getOrElse<bool>('bookingRequests', true),
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

