import 'package:formz/formz.dart';

enum EndTimeValidationError { invalid }

class EndTime
    extends FormzInput<DateTime, EndTimeValidationError> {
  EndTime.pure() : super.pure(DateTime.now());
  const EndTime.dirty(super.value) : super.dirty();

  @override
  EndTimeValidationError? validator(DateTime value) {
    return null;
  }
}
