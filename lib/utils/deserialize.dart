
import 'package:fpdart/fpdart.dart';

// firestore can suck my nuts for this
// firestore only stores "numbers" so I have to figure out if
// it's an int or double
Option<double> optionalDoubleFromJson(dynamic json) {
  final theDouble = switch (json.runtimeType) {
    String => const None(),
    double => Option.of(json as double),
    int => Option.of((json as int).toDouble()),
    _ => const None(),
  };

  return theDouble;
}