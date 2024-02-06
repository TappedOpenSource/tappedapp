part of 'discover_cubit.dart';

@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default([]) List<UserModel> hits,
  }) = _DiscoverState;
}
