import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@UsernameConverter()
class Username extends Equatable {
  // dart trick to create private constructor
  const Username._(this.username);

  factory Username.fromString(String input) {
    final username = input.trim().toLowerCase();
    return Username._(username);
  }

  final String username;

  @override
  List<Object> get props => [username];

  @override
  String toString() {
    return username;
  }

  static String usernameToString(Username? username) {
    return username?.username ?? '';
  }
}

class UsernameConverter implements JsonConverter<Username, String> {
  const UsernameConverter();

  @override
  Username fromJson(String json) => Username.fromString(json);

  @override
  String toJson(Username object) => object.username;
}