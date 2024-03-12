import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';

/// The Cubit responsible for changing the app's safety mode
class SafetyModeCubit extends HydratedCubit<bool> {
  /// The default theme is off
  SafetyModeCubit() : super(false);

  @override
  bool fromJson(Map<String, dynamic> json) => json['safety'] as bool;

  @override
  Map<String, dynamic> toJson(bool state) => {'safety': state};

  /// changes the app safety mode to be either safe mode
  void toggleSafetyMode() {
    logger.debug('updating safety mode to ${!state}');
    emit(!state);
  }

  /// Whether the app is in safe mode
  bool isSafe() {
    return state;
  }
}
