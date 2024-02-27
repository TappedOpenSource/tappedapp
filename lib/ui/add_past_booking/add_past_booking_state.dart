part of 'add_past_booking_cubit.dart';

class AddPastBookingState {
  AddPastBookingState({
    this.eventName = const None(),
    this.amountPaid = 0,
    this.place = const None(),
    this.duration = Duration.zero,
    DateTime? eventStart,
  }) {
    this.eventStart = eventStart ?? DateTime.now();
  }

  final Option<String> eventName;
  final int amountPaid;
  final Option<PlaceData> place;
  late final DateTime eventStart;
  final Duration duration;

  String get formattedStartDate {
    final outputFormat = DateFormat('MM/dd/yyyy');
    final outputDate = outputFormat.format(eventStart);
    return outputDate;
  }

  String get formattedStartTime {
    final outputFormat = DateFormat('HH:mm');
    final outputDate = outputFormat.format(eventStart);
    return outputDate;
  }

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '$hours hrs $minutes mins';
  }

  AddPastBookingState copyWith({
    Option<String>? eventName,
    int? amountPaid,
    Option<PlaceData>? place,
    DateTime? eventStart,
    Duration? duration,
  }) {
    return AddPastBookingState(
      eventName: eventName ?? this.eventName,
      amountPaid: amountPaid ?? this.amountPaid,
      place: place ?? this.place,
      eventStart: eventStart ?? this.eventStart,
      duration: duration ?? this.duration,
    );
  }
}
