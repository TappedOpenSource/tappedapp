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
      originalMessageId: json['originalMessageId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['originalMessageId'], (value) => value as String),
      latestMessageId: json['latestMessageId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['latestMessageId'], (value) => value as String),
      subject: json['subject'] == null
          ? const None()
          : Option<String>.fromJson(
              json['subject'], (value) => value as String),
      allEmails: (json['allEmails'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      collaborators: (json['collaborators'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      opportunityId: json['opportunityId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['opportunityId'], (value) => value as String),
    );

Map<String, dynamic> _$$ContactVenueRequestImplToJson(
        _$ContactVenueRequestImpl instance) =>
    <String, dynamic>{
      'venue': instance.venue.toJson(),
      'user': instance.user.toJson(),
      'bookingEmail': instance.bookingEmail,
      'note': instance.note,
      'timestamp': const DateTimeConverter().toJson(instance.timestamp),
      'originalMessageId': instance.originalMessageId.toJson(
        (value) => value,
      ),
      'latestMessageId': instance.latestMessageId.toJson(
        (value) => value,
      ),
      'subject': instance.subject.toJson(
        (value) => value,
      ),
      'allEmails': instance.allEmails,
      'collaborators': instance.collaborators.map((e) => e.toJson()).toList(),
      'opportunityId': instance.opportunityId.toJson(
        (value) => value,
      ),
    };
