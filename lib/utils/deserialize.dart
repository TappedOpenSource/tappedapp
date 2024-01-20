
import 'package:intheloopapp/domains/models/option.dart';

// firestore can suck my nuts for this
// firestore only stores "numbers" so I have to figure out if
// it's an int or double
Option<double> optionalDoubleFromJson(dynamic json) {
  final theDouble = switch (json.runtimeType) {
    String => const None<double>(),
    double => Some<double>(json as double),
    int => Some<double>((json as int).toDouble()),
    _ => const None<double>(),
  };

  return theDouble;
}