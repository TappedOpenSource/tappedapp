import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/domains/models/genre.dart';

part 'booking.freezed.dart';

part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String requesteeId,
    required BookingStatus status,
    @DateTimeConverter() required DateTime startTime,
    @DateTimeConverter() required DateTime endTime,
    @DateTimeConverter() required DateTime timestamp,
    @Default(None()) Option<String> requesterId,
    @Default(None()) Option<String> name,
    @Default('') String note,
    @Default(0) int rate,
    @Default(None()) Option<String> serviceId,
    @Default(false) bool addedByUser,
    @Default(None()) Option<String> placeId,
    @Default(None()) Option<String> geohash,
    @Default(None()) Option<double> lat,
    @Default(None()) Option<double> lng,
    @Default([]) List<Genre> genres,
    @Default(None()) Option<String> flierUrl,
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
