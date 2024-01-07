import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';

/// The Cubit responsible for changing the app's theme
class PremiumThemeCubit extends HydratedCubit<bool> {
  /// The default theme is premium mode
  PremiumThemeCubit() : super(false);

  @override
  bool fromJson(Map<String, dynamic> json) => json['isPremium'] as bool;

  @override
  Map<String, dynamic> toJson(bool state) => {'isPremium': state};

  /// changes the app theme to be either Premium mode
  /// with [isPremiumMode] being `true` or
  /// light mode with [isPremiumMode] being `false`
  void updateTheme({required bool isPremiumMode}) {
    logger.debug('updating premium theme to $isPremiumMode');
    emit(isPremiumMode);
  }

  /// Whether the app is Premium mode
  bool isPremium() {
    return state;
  }
}
