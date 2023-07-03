
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:intheloopapp/app_logger.dart';

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
