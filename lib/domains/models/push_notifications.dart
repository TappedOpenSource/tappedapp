
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'push_notifications.freezed.dart';
part 'push_notifications.g.dart';

@freezed
class PushNotifications with _$PushNotifications {
  const factory PushNotifications({
    @Default(true) bool appReleases,
    @Default(true) bool tappedUpdates,
    @Default(true) bool bookingRequests,
    @Default(true) bool directMessages,
  }) = _PushNotifications;

  // fromJson
  factory PushNotifications.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationsFromJson(json);

  // fromDoc
  factory PushNotifications.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document does not exist!');
    }
    return PushNotifications.fromJson(data);
  }

  // empty
  static const empty = PushNotifications();
}
