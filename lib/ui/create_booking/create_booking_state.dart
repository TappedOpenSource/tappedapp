part of 'create_booking_cubit.dart';

class CreateBookingState extends Equatable with FormzMixin {
  CreateBookingState({
    required this.currentUserId,
    required this.requesteeId,
    required this.service,
    required this.bookingFee,
    this.name = const BookingName.pure(),
    this.note = const BookingNote.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.place = const None(),
    this.placeId = const None(),
    int? rate,
    RateType? rateType,
    StartTime? startTime,
    EndTime? endTime,
    GlobalKey<FormState>? formKey,
  }) {
    this.rate = rate ?? service.fold(() => 0, (a) => a.rate);
    this.rateType = rateType ?? service.fold(() => RateType.fixed, (a) => a.rateType);
    this.startTime = startTime ?? StartTime.pure();
    this.endTime = endTime ?? EndTime.pure();
    this.formKey = formKey ?? GlobalKey<FormState>(debugLabel: 'settings');
  }

  final String currentUserId;
  final String requesteeId;
  final BookingName name;
  final BookingNote note;
  final Option<Service> service;
  final double bookingFee;
  final FormzSubmissionStatus status;
  late final int rate;
  late final RateType rateType;
  late final StartTime startTime;
  late final EndTime endTime;
  late final GlobalKey<FormState> formKey;

  final Option<PlaceData> place;
  final Option<String> placeId;

  @override
  List<Object?> get props => [
        currentUserId,
        requesteeId,
        service,
        bookingFee,
        name,
        note,
        status,
        startTime,
        endTime,
        rate,
        rateType,
        formKey,
        place,
        placeId,
      ];

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [
        name,
        note,
        startTime,
        endTime,
      ];

  CreateBookingState copyWith({
    String? currentUserId,
    String? requesteeId,
    Option<Service>? service,
    double? bookingFee,
    BookingName? name,
    BookingNote? note,
    StartTime? startTime,
    EndTime? endTime,
    int? rate,
    RateType? rateType,
    FormzSubmissionStatus? status,
    Option<PlaceData>? place,
    Option<String>? placeId,
  }) {
    return CreateBookingState(
      formKey: formKey,
      currentUserId: currentUserId ?? this.currentUserId,
      requesteeId: requesteeId ?? this.requesteeId,
      service: service ?? this.service,
      bookingFee: bookingFee ?? this.bookingFee,
      name: name ?? this.name,
      note: note ?? this.note,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      rate: rate ?? this.rate,
      rateType: rateType ?? this.rateType,
      status: status ?? this.status,
      place: place ?? this.place,
      placeId: placeId ?? this.placeId,
    );
  }

  String get formattedStartTime {
    final outputFormat = DateFormat('MM/dd/yyyy HH:mm');
    final outputDate = outputFormat.format(startTime.value);
    return outputDate;
  }

  String get formattedEndTime {
    final outputFormat = DateFormat('MM/dd/yyyy HH:mm');
    final outputDate = outputFormat.format(endTime.value);
    return outputDate;
  }

  String get formattedDuration {
    final d = endTime.value.difference(startTime.value);
    return d.toString().split('.').first.padLeft(8, '0');
  }

  int get performerCost {
    if (rateType == RateType.fixed) {
      return rate;
    }

    final d = endTime.value.difference(startTime.value);
    final rateInMinutes = rate / 60;
    final total = d.inMinutes * rateInMinutes;

    return total.toInt();
  }

  int get applicationFee {
    final total = performerCost;
    final fee = (total * bookingFee).toInt();
    return fee;
  }

  int get totalCost {
    final total = performerCost + applicationFee;
    return total;
  }

  String get formattedApplicationFee {
    final fee = applicationFee / 100;
    return '\$${fee.toStringAsFixed(2)}';
  }

  String get formattedArtistRate {
    final rate = performerCost / 100;
    return '\$${rate.toStringAsFixed(2)}';
  }

  String get formattedTotal {
    final total = totalCost / 100;
    return '\$${total.toStringAsFixed(2)}';
  }
}
