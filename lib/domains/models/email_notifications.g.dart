// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmailNotificationsImpl _$$EmailNotificationsImplFromJson(
        Map<String, dynamic> json) =>
    _$EmailNotificationsImpl(
      appReleases: json['appReleases'] as bool? ?? true,
      tappedUpdates: json['tappedUpdates'] as bool? ?? true,
      bookingRequests: json['bookingRequests'] as bool? ?? true,
    );

Map<String, dynamic> _$$EmailNotificationsImplToJson(
        _$EmailNotificationsImpl instance) =>
    <String, dynamic>{
      'appReleases': instance.appReleases,
      'tappedUpdates': instance.tappedUpdates,
      'bookingRequests': instance.bookingRequests,
    };
