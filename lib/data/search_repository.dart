import 'package:intheloopapp/domains/models/user_model.dart';

// ignore: one_member_abstracts
abstract class SearchRepository {
  Future<List<UserModel>> queryUsers(
    String input, {
    List<String>? labels,
    List<String>? genres,
    List<String>? occupations,
    double? lat,
    double? lng,
    int radius = 50000,
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
  Future<List<UserModel>> queryUsersInBoundingBox(
    String input, {
    required double swLatitude, required double swLongitude, required double neLatitude, required double neLongitude, List<String>? labels,
    List<String>? genres,
    List<String>? occupations,
  });
}
