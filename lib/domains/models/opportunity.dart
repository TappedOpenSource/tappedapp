import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/default_value.dart';

class Opportunity extends Equatable {
  const Opportunity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.flierUrl,
    required this.placeId,
    required this.geohash,
    required this.lat,
    required this.lng,
    required this.timestamp,
    required this.startTime,
    required this.endTime,
    required this.isPaid,
    required this.touched,
  });

  factory Opportunity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final touchedVal = doc.getOrElse('touched', null);
    final touched = touchedVal != null
        ? EnumToString.fromString<OpportunityInteration>(
            OpportunityInteration.values,
            touchedVal,
          )
        : null;
    return Opportunity(
      id: doc.id,
      userId: doc.get('userId') as String,
      title: doc.get('title') as String,
      description: doc.get('description') as String,
      flierUrl: Option.fromNullable(
        doc.getOrElse('flierUrl', null),
      ),
      placeId: doc.get('placeId') as String,
      geohash: doc.get('geohash') as String,
      lat: doc.get('lat') as double,
      lng: doc.get('lng') as double,
      timestamp: (doc.get('timestamp') as Timestamp).toDate(),
      startTime: (doc.get('startTime') as Timestamp).toDate(),
      endTime: (doc.get('endTime') as Timestamp).toDate(),
      isPaid: doc.getOrElse('isPaid', false),
      touched: Option.fromNullable(touched),
    );
  }

  final String id;
  final String userId;
  final String title;
  final String description;
  final Option<String> flierUrl;
  final String placeId;
  final String geohash;
  final double lat;
  final double lng;
  final DateTime timestamp;
  final DateTime startTime;
  final DateTime endTime;
  final bool isPaid;
  final Option<OpportunityInteration> touched;

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        flierUrl,
        placeId,
        geohash,
        lat,
        lng,
        timestamp,
        startTime,
        endTime,
        isPaid,
        touched,
      ];

  Opportunity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    Option<String>? flierUrl,
    String? placeId,
    String? geohash,
    double? lat,
    double? lng,
    DateTime? timestamp,
    DateTime? startTime,
    DateTime? endTime,
    bool? isPaid,
    Option<OpportunityInteration>? touched,
  }) {
    return Opportunity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      flierUrl: flierUrl ?? this.flierUrl,
      placeId: placeId ?? this.placeId,
      geohash: geohash ?? this.geohash,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      timestamp: timestamp ?? this.timestamp,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isPaid: isPaid ?? this.isPaid,
      touched: touched ?? this.touched,
    );
  }
}

enum OpportunityInteration { like, dislike }
