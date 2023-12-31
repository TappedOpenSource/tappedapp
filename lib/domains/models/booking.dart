import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:uuid/uuid.dart';

class Booking extends Equatable {
  Booking({
    required this.serviceId,
    required this.name,
    required this.note,
    required this.requesterId,
    required this.requesteeId,
    required this.status,
    required this.rate,
    required this.placeId,
    required this.geohash,
    required this.lat,
    required this.lng,
    required this.startTime,
    required this.endTime,
    required this.timestamp,
    String? id,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  factory Booking.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final tmpTimestamp =
        doc.getOrElse('timestamp', Timestamp.now()) ;
    final tmpStartTime =
        doc.getOrElse('startTime', Timestamp.now()) ;
    final tmpEndTime = doc.getOrElse('endTime', Timestamp.now()) ;
    return Booking(
      id: doc.id,
      serviceId: Option.fromNullable(
        doc.getOrElse<String?>('serviceId', null),
      ),
      name: doc.getOrElse('name', '') ,
      note: doc.getOrElse('note', '') ,
      requesterId: doc.getOrElse('requesterId', '') ,
      requesteeId: doc.getOrElse('requesteeId', '') ,
      rate: doc.getOrElse('rate', 0) ,
      status: EnumToString.fromString(
            BookingStatus.values,
            doc.getOrElse('status', '') ,
          ) ??
          BookingStatus.pending,
      placeId: Option.fromNullable(
        doc.getOrElse<String?>('placeId', null),
      ),
      geohash: Option.fromNullable(
        doc.getOrElse<String?>('geohash', null),
      ),
      lat: Option.fromNullable(
        doc.getOrElse<double?>('lat', null),
      ),
      lng: Option.fromNullable(
        doc.getOrElse<double?>('lng', null),
      ),
      startTime: tmpStartTime.toDate(),
      endTime: tmpEndTime.toDate(),
      timestamp: tmpTimestamp.toDate(),
    );
  }

  late final String id;
  final Option<String> serviceId;
  final String name;
  final String note;
  final String requesterId;
  final String requesteeId;
  final BookingStatus status;
  final int rate;

  final Option<String> placeId;
  final Option<String> geohash;
  final Option<double> lat;
  final Option<double> lng;

  final DateTime startTime;
  final DateTime endTime;
  final DateTime timestamp;

  @override
  List<Object?> get props => [
        id,
        serviceId,
        name,
        note,
        requesterId,
        requesteeId,
        status,
        rate,
        placeId,
        geohash,
        lat,
        lng,
        startTime,
        endTime,
        timestamp,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': serviceId.asNullable(),
      'name': name,
      'note': note,
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'rate': rate,
      'status': EnumToString.convertToString(status),
      'placeId': placeId.asNullable(),
      'geohash': geohash.asNullable(),
      'lat': lat.asNullable(),
      'lng': lng.asNullable(),
      'timestamp': Timestamp.fromDate(timestamp),
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
    };
  }

  Booking copyWith({
    String? id,
    Option<String>? serviceId,
    String? name,
    String? note,
    String? requesterId,
    String? requesteeId,
    int? rate,
    Option<String>? placeId,
    Option<String>? geohash,
    Option<double>? lat,
    Option<double>? lng,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? timestamp,
    BookingStatus? status,
  }) {
    return Booking(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      name: name ?? this.name,
      note: note ?? this.note,
      rate: rate ?? this.rate,
      requesterId: requesterId ?? this.requesterId,
      requesteeId: requesteeId ?? this.requesteeId,
      placeId: placeId ?? this.placeId,
      geohash: geohash ?? this.geohash,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  bool get isPending => status == BookingStatus.pending;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCanceled => status == BookingStatus.canceled;

  bool get isExpired => DateTime.now().isAfter(endTime);

  Duration get duration => endTime.difference(startTime);

  int get totalCost => ((rate / 60) * duration.inMinutes).toInt();
}

enum BookingStatus {
  pending,
  confirmed,
  canceled,
}
