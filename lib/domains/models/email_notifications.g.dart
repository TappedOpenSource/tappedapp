// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailNotifications _$EmailNotificationsFromJson(Map<String, dynamic> json) =>
    EmailNotifications(
      appReleases: json['appReleases'] as bool,
      tappedUpdates: json['tappedUpdates'] as bool,
      bookingRequests: json['bookingRequests'] as bool,
    );

Map<String, dynamic> _$EmailNotificationsToJson(EmailNotifications instance) =>
    <String, dynamic>{
      'appReleases': instance.appReleases,
      'tappedUpdates': instance.tappedUpdates,
      'bookingRequests': instance.bookingRequests,
    };
