import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/search_repository.dart';

import 'package:intheloopapp/domains/models/location.dart' as loc;
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/debouncer.dart';
import 'package:location/location.dart';

part 'discover_state.dart';

part 'discover_cubit.freezed.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit({
    required this.search,
  }) : super(const DiscoverState());

  final SearchRepository search;
  StreamSubscription<LocationData>? locationStream;

  @override
  Future<void> close() {
    locationStream?.cancel();
    return super.close();
  }

  final _debouncer = Debouncer(
    const Duration(milliseconds: 150),
    executionInterval: const Duration(milliseconds: 500),
  );

  Future<(double, double)> _getDefaultLocation(Location location) async {
    try {
      var serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return (loc.Location.rva.lat, loc.Location.rva.lng);
        }
      }

      var permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return (loc.Location.rva.lat, loc.Location.rva.lng);
        }
      }

      locationStream = location.onLocationChanged.listen((event) {
        logger.info('yeeeeeeeeeeeeeeeeeeeeerp');
        final lat = event.latitude;
        final lng = event.longitude;
        if (lat == null || lng == null) return;

        emit(
          state.copyWith(
            userLat: lat,
            userLng: lng,
          ),
        );
      });

      final locationData = await Future.any([
        location.getLocation(),
        Future.delayed(const Duration(seconds: 1), location.getLocation),
        Future.delayed(const Duration(seconds: 3), () => null),
      ]);

      return (
        locationData?.latitude ?? loc.Location.rva.lat,
        locationData?.longitude ?? loc.Location.rva.lng,
      );
    } catch (e, s) {
      logger.error('Error getting location', error: e, stackTrace: s);
      return (loc.Location.rva.lat, loc.Location.rva.lng);
    }
  }

  Future<void> initLocation() async {
    final location = Location();
    final (lat, lng) = await _getDefaultLocation(location);
    final hits = await getHits(
      lat: lat,
      lng: lng,
    );
    emit(
      state.copyWith(
        hits: hits,
        userLat: lat,
        userLng: lng,
      ),
    );
  }

  Future<List<UserModel>> getHits({
    required double lat,
    required double lng,
  }) async {
    final users = await search.queryUsers(
      '',
      occupations: ['Venue', 'venue'],
      lat: lat,
      lng: lng,
    );

    return users;
  }

  void onBoundsChange(LatLngBounds? bounds) {
    if (bounds == null) return;

    _debouncer.run(
      () async {
        final hits = await search.queryUsersInBoundingBox(
          '',
          occupations: ['Venue', 'venue'],
          swLatitude: bounds.southWest.latitude,
          swLongitude: bounds.southWest.longitude,
          neLatitude: bounds.northEast.latitude,
          neLongitude: bounds.northEast.longitude,
        );
        emit(state.copyWith(hits: hits));
      },
    );
  }
}
