import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils/default_value.dart';

class Opportunity extends Equatable {
  const Opportunity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.placeId,
    required this.geohash,
    required this.lat,
    required this.lng,
    required this.timestamp,
    required this.startTime,
    required this.endTime,
    required this.isPaid,
  });

  factory Opportunity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Opportunity(
      id: doc.id,
      userId: doc.get('userId') as String,
      title: doc.get('title') as String,
      description: doc.get('description') as String,
      placeId: doc.get('placeId') as String,
      geohash: doc.get('geohash') as String,
      lat: doc.get('lat') as double,
      lng: doc.get('lng') as double,
      timestamp: (doc.get('timestamp') as Timestamp).toDate(),
      startTime: (doc.get('startTime') as Timestamp).toDate(),
      endTime: (doc.get('endTime') as Timestamp).toDate(),
      isPaid: doc.getOrElse('isPaid', false),
    );
  }

  final String id;
  final String userId;
  final String title;
  final String description;
  final String placeId;
  final String geohash;
  final double lat;
  final double lng;
  final DateTime timestamp;
  final DateTime startTime;
  final DateTime endTime;
  final bool isPaid;

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        placeId,
        geohash,
        lat,
        lng,
        timestamp,
        startTime,
        endTime,
        isPaid,
      ];

  Opportunity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? placeId,
    String? geohash,
    double? lat,
    double? lng,
    DateTime? timestamp,
    DateTime? startTime,
    DateTime? endTime,
    bool? isPaid,
  }) {
    return Opportunity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      placeId: placeId ?? this.placeId,
      geohash: geohash ?? this.geohash,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      timestamp: timestamp ?? this.timestamp,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
