part of 'gig_search_cubit.dart';

@freezed
class GigSearchState with _$GigSearchState {
  const factory GigSearchState({
    @Default(None()) Option<PlaceData> place,
    @Default([]) List<Genre> genres,
    @Default([]) List<String> startDate,
    @Default([]) List<String> endDate,
    @Default(DateRangeType.fixed) DateRangeType dateRangeType,
    @Default([]) List<UserModel> results,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus formStatus,
  }) = _GigSearchState;
}

@JsonEnum()
enum DateRangeType {
  fixed,
  flexible,
}
