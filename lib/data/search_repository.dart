import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

// ignore: one_member_abstracts
abstract class SearchRepository {
  Future<List<UserModel>> queryUsers(String input, {
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
  });

  // Future<List<UserModel>> queryVenues(
  //   String input, {
  //   List<String>? labels,
  //   List<String>? genres,
  //   List<String>? occupations,
  //   double? lat,
  //   double? lng,
  //   int radius = 50000,
  // });

  Future<List<Booking>> queryBookings(String input, {
    double? lat,
    double? lng,
    int radius = 50000,
  });

  Future<List<Opportunity>> queryOpportunities(String input, {
    double? lat,
    double? lng,
    int radius = 50000,
    DateTime? startTime,
  });

  Future<List<UserModel>> queryUsersInBoundingBox(String input, {
    required double swLatitude,
    required double swLongitude,
    required double neLatitude,
    required double neLongitude,
    List<String>? labels,
    List<String>? genres,
    List<String>? venueGenres,
    List<String>? occupations,
    int? minCapacity,
    int? maxCapacity,
    int limit = 100,
  });

  Future<List<Booking>> queryBookingsInBoundingBox(String input, {
    required double swLatitude,
    required double swLongitude,
    required double neLatitude,
    required double neLongitude,
    int limit = 100,
  });

  Future<List<Opportunity>> queryOpportunitiesInBoundingBox(String input, {
    required double swLatitude,
    required double swLongitude,
    required double neLatitude,
    required double neLongitude,
    int limit = 100,
    DateTime? startTime,
  });
}
