import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:stack_trace/stack_trace.dart';

Future<void> configureError() async {
  FlutterError.onError = (errorDetails) {
    try {
      logger.error(
        errorDetails.exceptionAsString(),
        error: errorDetails.exception,
        stackTrace: errorDetails.stack,
      );
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    } catch (e) {
      logger.debug('Failed to report error to Firebase Crashlytics');
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    try {
      logger.error('error', error: error, stackTrace: stack, fatal: true);
      return true;
    } catch (e) {
      logger.debug('Failed to report error to Firebase Crashlytics: $e');
      return false;
    }
  };

  if (kDebugMode) {
    // Force disable Crashlytics collection
    // while doing every day development.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
}

/// Rethrows [error] with a stacktrace that is the combination of [stackTrace]
/// and [StackTrace.current].
Never throwErrorWithCombinedStackTrace(Object error, StackTrace stackTrace) {
  final chain = Chain([
    Trace.current(),
    ...Chain.forTrace(stackTrace).traces,
  ]).foldFrames((frame) => frame.package == 'intheloopapp');

  Error.throwWithStackTrace(error, chain.toTrace().vmTrace);
}
