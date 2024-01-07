import 'package:formz/formz.dart';

class StartTime extends FormzInput<DateTime, StartTimeValidationError> {
  StartTime.pure() : super.pure(DateTime.now());
  const StartTime.dirty(super.value) : super.dirty();

  @override
  StartTimeValidationError? validator(DateTime value) {
    return null;
  }
}

enum StartTimeValidationError { invalid }
