part of 'create_opportunity_cubit.dart';

class CreateOpportunityState extends Equatable {
  CreateOpportunityState({
    this.title = '',
    this.description = '',
    this.isPaid = false,
    this.pickedPhoto = const None(),
    this.placeData,
    this.placeId,
    ImagePicker? picker,
    StartTime? startTime,
    EndTime? endTime,
  }) {
    this.startTime = startTime ?? StartTime.pure();
    this.endTime = endTime ?? EndTime.pure();
    this.picker = picker ?? ImagePicker();
  }

  final String title;
  final String description;
  final PlaceData? placeData;
  final bool isPaid;
  final String? placeId;
  late final StartTime startTime;
  late final EndTime endTime;
  late final ImagePicker picker;
  final Option<File> pickedPhoto;

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

  @override
  List<Object?> get props => [
        title,
        description,
        isPaid,
        placeId,
        placeData,
        startTime,
        endTime,
        pickedPhoto,
      ];

  CreateOpportunityState copyWith({
    String? title,
    String? description,
    bool? isPaid,
    PlaceData? placeData,
    String? placeId,
    StartTime? startTime,
    EndTime? endTime,
    Option<File>? pickedPhoto,
  }) {
    return CreateOpportunityState(
      title: title ?? this.title,
      description: description ?? this.description,
      isPaid: isPaid ?? this.isPaid,
      placeData: placeData ?? this.placeData,
      placeId: placeId ?? this.placeId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pickedPhoto: pickedPhoto ?? this.pickedPhoto,
    );
  }
}
