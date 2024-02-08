// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_venue_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactVenueRequestImpl _$$ContactVenueRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ContactVenueRequestImpl(
      venue: UserModel.fromJson(json['venue'] as Map<String, dynamic>),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      bookingEmail: json['bookingEmail'] as String,
      note: json['note'] as String,
      timestamp:
          const DateTimeConverter().fromJson(json['timestamp'] as Timestamp),
      messageId: json['messageId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['messageId'], (value) => value as String),
      subject: json['subject'] == null
          ? const None()
          : Option<String>.fromJson(
              json['subject'], (value) => value as String),
      allEmails: (json['allEmails'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ContactVenueRequestImplToJson(
        _$ContactVenueRequestImpl instance) =>
    <String, dynamic>{
      'venue': instance.venue,
      'user': instance.user,
      'bookingEmail': instance.bookingEmail,
      'note': instance.note,
      'timestamp': const DateTimeConverter().toJson(instance.timestamp),
      'messageId': instance.messageId.toJson(
        (value) => value,
      ),
      'subject': instance.subject.toJson(
        (value) => value,
      ),
      'allEmails': instance.allEmails,
    };
