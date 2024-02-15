// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gig_search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GigSearchState {
  Option<PlaceData> get place => throw _privateConstructorUsedError;
  List<Genre> get genres => throw _privateConstructorUsedError;
  List<String> get startDate => throw _privateConstructorUsedError;
  List<String> get endDate => throw _privateConstructorUsedError;
  DateRangeType get dateRangeType => throw _privateConstructorUsedError;
  List<SelectableResult> get results => throw _privateConstructorUsedError;
  FormzSubmissionStatus get formStatus => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GigSearchStateCopyWith<GigSearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GigSearchStateCopyWith<$Res> {
  factory $GigSearchStateCopyWith(
          GigSearchState value, $Res Function(GigSearchState) then) =
      _$GigSearchStateCopyWithImpl<$Res, GigSearchState>;
  @useResult
  $Res call(
      {Option<PlaceData> place,
      List<Genre> genres,
      List<String> startDate,
      List<String> endDate,
      DateRangeType dateRangeType,
      List<SelectableResult> results,
      FormzSubmissionStatus formStatus});
}

/// @nodoc
class _$GigSearchStateCopyWithImpl<$Res, $Val extends GigSearchState>
    implements $GigSearchStateCopyWith<$Res> {
  _$GigSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? place = null,
    Object? genres = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? dateRangeType = null,
    Object? results = null,
    Object? formStatus = null,
  }) {
    return _then(_value.copyWith(
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as Option<PlaceData>,
      genres: null == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<Genre>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dateRangeType: null == dateRangeType
          ? _value.dateRangeType
          : dateRangeType // ignore: cast_nullable_to_non_nullable
              as DateRangeType,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<SelectableResult>,
      formStatus: null == formStatus
          ? _value.formStatus
          : formStatus // ignore: cast_nullable_to_non_nullable
              as FormzSubmissionStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GigSearchStateImplCopyWith<$Res>
    implements $GigSearchStateCopyWith<$Res> {
  factory _$$GigSearchStateImplCopyWith(_$GigSearchStateImpl value,
          $Res Function(_$GigSearchStateImpl) then) =
      __$$GigSearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Option<PlaceData> place,
      List<Genre> genres,
      List<String> startDate,
      List<String> endDate,
      DateRangeType dateRangeType,
      List<SelectableResult> results,
      FormzSubmissionStatus formStatus});
}

/// @nodoc
class __$$GigSearchStateImplCopyWithImpl<$Res>
    extends _$GigSearchStateCopyWithImpl<$Res, _$GigSearchStateImpl>
    implements _$$GigSearchStateImplCopyWith<$Res> {
  __$$GigSearchStateImplCopyWithImpl(
      _$GigSearchStateImpl _value, $Res Function(_$GigSearchStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? place = null,
    Object? genres = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? dateRangeType = null,
    Object? results = null,
    Object? formStatus = null,
  }) {
    return _then(_$GigSearchStateImpl(
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as Option<PlaceData>,
      genres: null == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<Genre>,
      startDate: null == startDate
          ? _value._startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      endDate: null == endDate
          ? _value._endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dateRangeType: null == dateRangeType
          ? _value.dateRangeType
          : dateRangeType // ignore: cast_nullable_to_non_nullable
              as DateRangeType,
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<SelectableResult>,
      formStatus: null == formStatus
          ? _value.formStatus
          : formStatus // ignore: cast_nullable_to_non_nullable
              as FormzSubmissionStatus,
    ));
  }
}

/// @nodoc

class _$GigSearchStateImpl implements _GigSearchState {
  const _$GigSearchStateImpl(
      {this.place = const None(),
      final List<Genre> genres = const [],
      final List<String> startDate = const [],
      final List<String> endDate = const [],
      this.dateRangeType = DateRangeType.fixed,
      final List<SelectableResult> results = const [],
      this.formStatus = FormzSubmissionStatus.initial})
      : _genres = genres,
        _startDate = startDate,
        _endDate = endDate,
        _results = results;

  @override
  @JsonKey()
  final Option<PlaceData> place;
  final List<Genre> _genres;
  @override
  @JsonKey()
  List<Genre> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  final List<String> _startDate;
  @override
  @JsonKey()
  List<String> get startDate {
    if (_startDate is EqualUnmodifiableListView) return _startDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_startDate);
  }

  final List<String> _endDate;
  @override
  @JsonKey()
  List<String> get endDate {
    if (_endDate is EqualUnmodifiableListView) return _endDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_endDate);
  }

  @override
  @JsonKey()
  final DateRangeType dateRangeType;
  final List<SelectableResult> _results;
  @override
  @JsonKey()
  List<SelectableResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  @JsonKey()
  final FormzSubmissionStatus formStatus;

  @override
  String toString() {
    return 'GigSearchState(place: $place, genres: $genres, startDate: $startDate, endDate: $endDate, dateRangeType: $dateRangeType, results: $results, formStatus: $formStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GigSearchStateImpl &&
            (identical(other.place, place) || other.place == place) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            const DeepCollectionEquality()
                .equals(other._startDate, _startDate) &&
            const DeepCollectionEquality().equals(other._endDate, _endDate) &&
            (identical(other.dateRangeType, dateRangeType) ||
                other.dateRangeType == dateRangeType) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.formStatus, formStatus) ||
                other.formStatus == formStatus));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      place,
      const DeepCollectionEquality().hash(_genres),
      const DeepCollectionEquality().hash(_startDate),
      const DeepCollectionEquality().hash(_endDate),
      dateRangeType,
      const DeepCollectionEquality().hash(_results),
      formStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GigSearchStateImplCopyWith<_$GigSearchStateImpl> get copyWith =>
      __$$GigSearchStateImplCopyWithImpl<_$GigSearchStateImpl>(
          this, _$identity);
}

abstract class _GigSearchState implements GigSearchState {
  const factory _GigSearchState(
      {final Option<PlaceData> place,
      final List<Genre> genres,
      final List<String> startDate,
      final List<String> endDate,
      final DateRangeType dateRangeType,
      final List<SelectableResult> results,
      final FormzSubmissionStatus formStatus}) = _$GigSearchStateImpl;

  @override
  Option<PlaceData> get place;
  @override
  List<Genre> get genres;
  @override
  List<String> get startDate;
  @override
  List<String> get endDate;
  @override
  DateRangeType get dateRangeType;
  @override
  List<SelectableResult> get results;
  @override
  FormzSubmissionStatus get formStatus;
  @override
  @JsonKey(ignore: true)
  _$$GigSearchStateImplCopyWith<_$GigSearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SelectableResult {
  UserModel get user => throw _privateConstructorUsedError;
  bool get selected => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SelectableResultCopyWith<SelectableResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectableResultCopyWith<$Res> {
  factory $SelectableResultCopyWith(
          SelectableResult value, $Res Function(SelectableResult) then) =
      _$SelectableResultCopyWithImpl<$Res, SelectableResult>;
  @useResult
  $Res call({UserModel user, bool selected});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$SelectableResultCopyWithImpl<$Res, $Val extends SelectableResult>
    implements $SelectableResultCopyWith<$Res> {
  _$SelectableResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? selected = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SelectableResultImplCopyWith<$Res>
    implements $SelectableResultCopyWith<$Res> {
  factory _$$SelectableResultImplCopyWith(_$SelectableResultImpl value,
          $Res Function(_$SelectableResultImpl) then) =
      __$$SelectableResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserModel user, bool selected});

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$SelectableResultImplCopyWithImpl<$Res>
    extends _$SelectableResultCopyWithImpl<$Res, _$SelectableResultImpl>
    implements _$$SelectableResultImplCopyWith<$Res> {
  __$$SelectableResultImplCopyWithImpl(_$SelectableResultImpl _value,
      $Res Function(_$SelectableResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? selected = null,
  }) {
    return _then(_$SelectableResultImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SelectableResultImpl implements _SelectableResult {
  const _$SelectableResultImpl({required this.user, required this.selected});

  @override
  final UserModel user;
  @override
  final bool selected;

  @override
  String toString() {
    return 'SelectableResult(user: $user, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectableResultImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, selected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectableResultImplCopyWith<_$SelectableResultImpl> get copyWith =>
      __$$SelectableResultImplCopyWithImpl<_$SelectableResultImpl>(
          this, _$identity);
}

abstract class _SelectableResult implements SelectableResult {
  const factory _SelectableResult(
      {required final UserModel user,
      required final bool selected}) = _$SelectableResultImpl;

  @override
  UserModel get user;
  @override
  bool get selected;
  @override
  @JsonKey(ignore: true)
  _$$SelectableResultImplCopyWith<_$SelectableResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
