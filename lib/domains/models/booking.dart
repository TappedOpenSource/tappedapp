import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/default_image.dart';

part 'booking.freezed.dart';

part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  @JsonSerializable(explicitToJson: true)
  const factory Booking({
    required String id,
    required String requesteeId,
    required BookingStatus status,
    @Default(false) bool verified,
    @DateTimeConverter() required DateTime startTime,
    @DateTimeConverter() required DateTime endTime,
    @DateTimeConverter() required DateTime timestamp,
    @Default(None()) Option<String> requesterId,
    @Default(None()) Option<String> name,
    @Default('') String note,
    @Default(0) int rate,
    @Default(None()) Option<String> serviceId,
    @Default(false) bool addedByUser,
    @Default(None()) Option<String> flierUrl,
    @Default(None()) Option<String> eventUrl,
    @Default([]) List<String> genres,
    @Default(None()) Option<Location> location,
    @Default([]) List<String> socialMediaLinks,
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

  ImageProvider getBookingImage(Option<UserModel> user) {
    return flierUrl.fold(
          () => user.flatMap((t) => t.profilePicture).fold(
            () => getDefaultImage(Option.of(id)),
            (t) {
          if (t.isNotEmpty) {
            return CachedNetworkImageProvider(t);
          }
          return getDefaultImage(Option.of(id));
        },
      ),
      CachedNetworkImageProvider.new,
    );
  }
}

@JsonEnum()
enum BookingStatus {
  pending,
  confirmed,
  canceled,
}

extension BookingStatusX on BookingStatus {
  String get formattedName {
    return switch (this) {
      BookingStatus.pending => 'Pending',
      BookingStatus.confirmed => 'Confirmed',
      BookingStatus.canceled => 'Canceled',
    };
  }
}
