part of 'create_opportunity_cubit.dart';

class CreateOpportunityState extends Equatable {
  CreateOpportunityState({
    this.loading = false,
    this.title = '',
    this.description = '',
    this.isPaid = false,
    this.pickedPhoto = const None(),
    this.placeId = const None(),
    this.placeData = const None(),
    ImagePicker? picker,
    StartTime? startTime,
    EndTime? endTime,
  }) {
    this.startTime = startTime ?? StartTime.pure();
    this.endTime = endTime ?? EndTime.pure();
    this.picker = picker ?? ImagePicker();
  }

  final bool loading;
  final String title;
  final String description;
  final bool isPaid;
  final Option<PlaceData> placeData;
  final Option<String> placeId;
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

  Duration get duration {
    return endTime.value.difference(startTime.value);
  }

  @override
  List<Object?> get props => [
        loading,
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
    bool? loading,
    String? title,
    String? description,
    bool? isPaid,
    Option<PlaceData>? placeData,
    Option<String>? placeId,
    StartTime? startTime,
    EndTime? endTime,
    Option<File>? pickedPhoto,
  }) {
    return CreateOpportunityState(
      loading: loading ?? this.loading,
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
