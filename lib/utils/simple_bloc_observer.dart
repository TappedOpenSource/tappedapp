import 'package:bloc/bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.debug('bloc transition ${bloc.runtimeType}, $event');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    logger.debug('bloc transition ${bloc.runtimeType}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.error('bloc error', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
