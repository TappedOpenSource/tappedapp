part of 'add_past_booking_cubit.dart';

class AddPastBookingState {
  AddPastBookingState({
    this.eventName = const None(),
    this.amountPaid = 0,
    this.place = const None(),
    this.venue = const None(),
    this.duration = Duration.zero,
    this.flierFile = const None(),
    DateTime? eventStart,
  }) {
    this.eventStart = eventStart ?? DateTime.now();
  }

  final Option<String> eventName;
  final int amountPaid;
  final Option<PlaceData> place;
  final Option<UserModel> venue;
  late final DateTime eventStart;
  final Duration duration;
  final Option<File> flierFile;

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


  String get formattedAmount {
    final total = amountPaid / 100;
    return '\$${total.toStringAsFixed(2)}';
  }

  AddPastBookingState copyWith({
    Option<String>? eventName,
    int? amountPaid,
    Option<PlaceData>? place,
    Option<UserModel>? venue,
    DateTime? eventStart,
    Duration? duration,
    Option<File>? flierFile,
  }) {
    return AddPastBookingState(
      eventName: eventName ?? this.eventName,
      amountPaid: amountPaid ?? this.amountPaid,
      place: place ?? this.place,
      venue: venue ?? this.venue,
      eventStart: eventStart ?? this.eventStart,
      duration: duration ?? this.duration,
      flierFile: flierFile ?? this.flierFile,
    );
  }
}
