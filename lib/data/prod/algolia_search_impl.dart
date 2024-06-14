import 'package:algolia/algolia.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

final _analytics = FirebaseAnalytics.instance;
final _fireStore = FirebaseFirestore.instance;
final usersRef = _fireStore.collection('users');
final bookingsRef = _fireStore.collection('bookings');
final opportunitiesRef = _fireStore.collection('opportunities');

class AlgoliaSearchImpl extends SearchRepository {
  AlgoliaSearchImpl({
    required String applicationId,
    required String apiKey,
  }) : algolia = Algolia.init(
          applicationId: applicationId,
          apiKey: apiKey,
        ).instance;

  final Algolia algolia;

  @cached
  Future<Booking> _getBooking(String bookingId) async {
    final bookingSnapshot = await bookingsRef.doc(bookingId).get();
    final booking = Booking.fromDoc(bookingSnapshot);

    return booking;
  }

  @cached
  Future<Opportunity> _getOpportunity(String opportunityId) async {
    final opportunitySnapshot = await opportunitiesRef.doc(opportunityId).get();
    final opportunity = Opportunity.fromDoc(opportunitySnapshot);

    return opportunity;
  }

  @override
  @Cached(ttl: 300) // 5 minutes
  Future<List<UserModel>> queryUsers(
    String input, {
    List<String>? labels,
    List<String>? genres,
    List<String>? venueGenres,
    List<String>? occupations,
    bool? unclaimed,
    int? minCapacity,
    int? maxCapacity,
    double? lat,
    double? lng,
    int radius = 50000,
    int limit = 20,
  }) async {
    var results = <AlgoliaObjectSnapshot>[];

    const formattedIsDeletedFilter = 'deleted:false';
    final formattedLabelFilter = labels != null
        ? '(${labels.map((e) => "performerInfo.label:'$e'").join(' OR ')})'
        : null;
    final formattedGenreFilter = genres != null
        ? '(${genres.map((e) => "performerInfo.genres:'$e'").join(' OR ')})'
        : null;
    final formattedOccupationFilter = occupations != null
        ? '(${occupations.map((e) => "occupations:'$e'").join(' OR ')})'
        : null;
    final formattedVenueGenreFilter = venueGenres != null
        ? '(${venueGenres.map((e) => "venueInfo.genres:'$e'").join(' OR ')})'
        : null;
    final formattedUnclaimedFilter =
        unclaimed != null ? 'unclaimed:$unclaimed' : null;

    final filters = [
      formattedIsDeletedFilter,
      formattedLabelFilter,
      formattedGenreFilter,
      formattedOccupationFilter,
      formattedVenueGenreFilter,
      formattedUnclaimedFilter,
    ]..removeWhere((element) => element == null);

    final formattedLocationFilter =
        (lat != null && lng != null) ? '$lat, $lng' : null;

    try {
      // print(filters.join(' AND '));

      var query = algolia.index('prod_users').query(input).filters(
            filters.join(' AND '),
          );

      if (formattedLocationFilter != null) {
        query = query.setAroundLatLng(formattedLocationFilter);
      }

      if (minCapacity != null) {
        query = query.setNumericFilter('venueInfo.capacity>=$minCapacity');
      }

      if (maxCapacity != null) {
        query = query.setNumericFilter('venueInfo.capacity<=$maxCapacity');
      }

      query = query.setAroundRadius(radius);

      query = query.setHitsPerPage(limit);

      final snap = await query.getObjects();

      await _analytics.logSearch(searchTerm: input);

      results = snap.hits;
    } on AlgoliaError {
      // print(e.error);
      rethrow;
    }

    final hits = results.map((res) {
      final hitData = res.data;
      final tmpTimestamp = hitData['timestamp'] as int?;
      hitData['timestamp'] = tmpTimestamp == null
          ? null
          : Timestamp.fromMillisecondsSinceEpoch(tmpTimestamp);

      return UserModel.fromJson(hitData);
    }).toList();

    return hits;
  }

  @override
  Future<List<Booking>> queryBookings(
    String input, {
    double? lat,
    double? lng,
    int radius = 50000,
  }) async {
    var results = <AlgoliaObjectSnapshot>[];

    final formattedLocationFilter =
        (lat != null && lng != null) ? '$lat, $lng' : null;

    try {
      var query = algolia.index('prod_bookings').query(input);

      if (formattedLocationFilter != null) {
        query = query.setAroundLatLng(formattedLocationFilter);
      }

      query = query.setAroundRadius(radius);

      final snap = await query.getObjects();

      await _analytics.logSearch(searchTerm: input);

      results = snap.hits;
    } on AlgoliaError {
      // print(e.error);
      rethrow;
    }

    final bookingResults = await Future.wait(
      results.map((res) async {
        final user = await _getBooking(res.objectID);
        return user;
      }),
    );

    return bookingResults;
  }

  @override
  Future<List<Opportunity>> queryOpportunities(
    String input, {
    double? lat,
    double? lng,
    int radius = 50000,
    DateTime? startTime,
  }) async {
    var results = <AlgoliaObjectSnapshot>[];

    final formattedLocationFilter =
        (lat != null && lng != null) ? '$lat, $lng' : null;

    try {
      var query = algolia
            .index('prod_opportunities')
          .query(input)
          .filters([
            'deleted:false',
            if (startTime != null)
              'startTime:${startTime.toUtc().millisecondsSinceEpoch}',
          ].join(' AND ')
      );

      if (formattedLocationFilter != null) {
        query = query.setAroundLatLng(formattedLocationFilter);
      }

      query = query.setAroundRadius(radius);

      final snap = await query.getObjects();

      await _analytics.logSearch(searchTerm: input);

      results = snap.hits;
    } on AlgoliaError {
      // print(e.error);
      rethrow;
    }

    final opportunityResults = await Future.wait(
      results.map((res) async {
        final user = await _getOpportunity(res.objectID);
        return user;
      }),
    );

    return opportunityResults;
  }

  @override
  Future<List<UserModel>> queryUsersInBoundingBox(
    String input, {
    required double swLatitude,
    required double swLongitude,
    required double neLatitude,
    required double neLongitude,
    List<String>? labels,
    List<String>? genres,
    List<String>? venueGenres,
    List<String>? occupations,
    int limit = 100,
  }) async {
    var results = <AlgoliaObjectSnapshot>[];

    const formattedIsDeletedFilter = 'deleted:false';
    final formattedLabelFilter = labels != null
        ? '(${labels.map((e) => "performerInfo.label:'$e'").join(' OR ')})'
        : null;
    final formattedGenreFilter = genres != null
        ? '(${genres.map((e) => "performerInfo.genres:'$e'").join(' OR ')})'
        : null;
    final formattedOccupationFilter = occupations != null
        ? '(${occupations.map((e) => "occupations:'$e'").join(' OR ')})'
        : null;
    final formattedVenueGenreFilter = venueGenres != null
        ? '(${venueGenres.map((e) => "venueInfo.genres:'$e'").join(' OR ')})'
        : null;

    final filters = [
      formattedIsDeletedFilter,
      formattedLabelFilter,
      formattedGenreFilter,
      formattedOccupationFilter,
      formattedVenueGenreFilter,
    ]..removeWhere((element) => element == null);

    try {
      // print(filters.join(' AND '));
      final query = algolia
          .index('prod_users')
          .query(input)
          .filters(
            filters.join(' AND '),
          )
          .setInsideBoundingBox([
        BoundingBox(
          p1Lat: swLatitude,
          p1Lng: swLongitude,
          p2Lat: neLatitude,
          p2Lng: neLongitude,
        ),
      ]).setHitsPerPage(limit);
      final snap = await query.getObjects();

      await _analytics.logSearch(searchTerm: input);

      results = snap.hits;
    } on AlgoliaError {
      // print(e.error);
      rethrow;
    }

    final hits = results.map((res) {
      final hitData = res.data;
      final tmpTimestamp = hitData['timestamp'] as int?;
      hitData['timestamp'] = tmpTimestamp == null
          ? null
          : Timestamp.fromMillisecondsSinceEpoch(tmpTimestamp);

      return UserModel.fromJson(hitData);
    }).toList();

    return hits;
  }

  @override
  Future<List<Booking>> queryBookingsInBoundingBox(
    String input, {
    required double swLatitude,
    required double swLongitude,
    required double neLatitude,
    required double neLongitude,
    int limit = 100,
  }) async {
    var results = <AlgoliaObjectSnapshot>[];

    try {
      final query =
          algolia.index('prod_bookings').query(input).setInsideBoundingBox([
        BoundingBox(
          p1Lat: swLatitude,
          p1Lng: swLongitude,
          p2Lat: neLatitude,
          p2Lng: neLongitude,
        ),
      ]).setHitsPerPage(limit);
      final snap = await query.getObjects();

      await _analytics.logSearch(searchTerm: input);

      results = snap.hits;
    } on AlgoliaError {
      // print(e.error);
      rethrow;
    }

    final bookingResults = await Future.wait(
      results.map((res) async {
        final user = await _getBooking(res.objectID);
        return user;
      }),
    );

    return bookingResults;
  }

  @override
  Future<List<Opportunity>> queryOpportunitiesInBoundingBox(
    String input, {
    required double swLatitude,
    required double swLongitude,
    required double neLatitude,
    required double neLongitude,
    int limit = 100,
  }) async {
    var results = <AlgoliaObjectSnapshot>[];

    try {
      final query = algolia
          .index('prod_opportunities')
          .query(input)
          .setInsideBoundingBox([
        BoundingBox(
          p1Lat: swLatitude,
          p1Lng: swLongitude,
          p2Lat: neLatitude,
          p2Lng: neLongitude,
        ),
      ]).setHitsPerPage(limit);
      final snap = await query.getObjects();

      await _analytics.logSearch(searchTerm: input);

      results = snap.hits;
    } on AlgoliaError {
      // print(e.error);
      rethrow;
    }

    final opportunityResults = await Future.wait(
      results.map((res) async {
        final user = await _getOpportunity(res.objectID);
        return user;
      }),
    );

    return opportunityResults;
  }
}
