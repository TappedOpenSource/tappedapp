// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotifications _$PushNotificationsFromJson(Map<String, dynamic> json) =>
    PushNotifications(
      appReleases: json['appReleases'] as bool,
      tappedUpdates: json['tappedUpdates'] as bool,
      bookingRequests: json['bookingRequests'] as bool,
      directMessages: json['directMessages'] as bool,
    );

Map<String, dynamic> _$PushNotificationsToJson(PushNotifications instance) =>
    <String, dynamic>{
      'appReleases': instance.appReleases,
      'tappedUpdates': instance.tappedUpdates,
      'bookingRequests': instance.bookingRequests,
      'directMessages': instance.directMessages,
    };
