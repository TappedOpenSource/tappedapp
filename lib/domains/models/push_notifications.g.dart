// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PushNotificationsImpl _$$PushNotificationsImplFromJson(
        Map<String, dynamic> json) =>
    _$PushNotificationsImpl(
      appReleases: json['appReleases'] as bool? ?? true,
      tappedUpdates: json['tappedUpdates'] as bool? ?? true,
      bookingRequests: json['bookingRequests'] as bool? ?? true,
      directMessages: json['directMessages'] as bool? ?? true,
    );

Map<String, dynamic> _$$PushNotificationsImplToJson(
        _$PushNotificationsImpl instance) =>
    <String, dynamic>{
      'appReleases': instance.appReleases,
      'tappedUpdates': instance.tappedUpdates,
      'bookingRequests': instance.bookingRequests,
      'directMessages': instance.directMessages,
    };
