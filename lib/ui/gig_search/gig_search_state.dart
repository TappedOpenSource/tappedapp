part of 'gig_search_cubit.dart';

@freezed
class GigSearchState with _$GigSearchState {
  const factory GigSearchState({
    @Default(None()) Option<PlaceData> place,
    @Default([]) List<Genre> genres,
    @Default([]) List<String> startDate,
    @Default([]) List<String> endDate,
    @Default(RangeValues(0, 200)) RangeValues capacityRange,
    @Default(DateRangeType.fixed) DateRangeType dateRangeType,
    @Default([]) List<SelectableResult> results,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus formStatus,
  }) = _GigSearchState;
}

extension SelectedGigSearch on GigSearchState {
  bool get allSelected {
    return results.every((result) => result.selected);
  }

  List<UserModel> get selectedResults {
    return results
        .where((result) => result.selected)
        .map((e) => e.user)
        .toList();
  }
}

@JsonEnum()
enum DateRangeType {
  fixed,
  flexible,
}

@freezed
class SelectableResult with _$SelectableResult {
  const factory SelectableResult({
    required UserModel user,
    required bool selected,
  }) = _SelectableResult;
}
