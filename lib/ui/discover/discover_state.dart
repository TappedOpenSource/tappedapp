part of 'discover_cubit.dart';

@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default([]) List<UserModel> hits,
    @Default(37.5407246) double defaultLat,
    @Default(-77.4360481) double defaultLng,
  }) = _DiscoverState;
}
