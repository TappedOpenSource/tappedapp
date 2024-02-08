part of 'discover_cubit.dart';

@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default([]) List<UserModel> hits,
    @Default(37.5407246) double userLat,
    @Default(-77.4360481) double userLng,
  }) = _DiscoverState;
}
