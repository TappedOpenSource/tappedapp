import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:uuid/uuid.dart';

part 'booking.freezed.dart';

part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String name,
    required String note,
    required String requesterId,
    required String requesteeId,
    required BookingStatus status,
    required int rate,
    @DateTimeConverter() required DateTime startTime,
    @DateTimeConverter() required DateTime endTime,
    @DateTimeConverter() required DateTime timestamp,
    @Default(None()) Option<String> serviceId,
    @Default(None()) Option<String> placeId,
    @Default(None()) Option<String> geohash,
    @Default(None()) Option<double> lat,
    @Default(None()) Option<double> lng,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  factory Booking.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document does not exist!');
    }

    data['id'] = doc.id;
    return Booking.fromJson(data);
  }
}

extension BookingHelpers on Booking {
  bool get isPending => status == BookingStatus.pending;

  bool get isConfirmed => status == BookingStatus.confirmed;

  bool get isCanceled => status == BookingStatus.canceled;

  bool get isExpired => DateTime.now().isAfter(endTime);

  Duration get duration => endTime.difference(startTime);

  int get totalCost => ((rate / 60) * duration.inMinutes).toInt();
}

@JsonEnum()
enum BookingStatus {
  pending,
  confirmed,
  canceled,
}
