import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_notifications.freezed.dart';
part 'email_notifications.g.dart';

@freezed
class EmailNotifications with _$EmailNotifications  {
  const factory EmailNotifications({
    @Default(true) bool appReleases,
    @Default(true) bool tappedUpdates,
    @Default(true) bool bookingRequests,
  }) = _EmailNotifications;

  // fromJson
  factory EmailNotifications.fromJson(Map<String, dynamic> json) =>
      _$EmailNotificationsFromJson(json);

  // fromDoc
  factory EmailNotifications.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document does not exist!');
    }
    return EmailNotifications.fromJson(data);
  }

  // empty
  static const empty = EmailNotifications(
    appReleases: true,
    tappedUpdates: true,
    bookingRequests: true,
  );
}

