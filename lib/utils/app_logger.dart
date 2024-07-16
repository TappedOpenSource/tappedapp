import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:logging/logging.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

final logger = AppLogger();
final analytics = FirebaseAnalytics.instance;

class AppLogger {
  AppLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      FirebaseCrashlytics.instance.log(record.message);
      if (kDebugMode) {
        print(
        // ignore: lines_longer_than_80_chars
        '${record.level.name}: ${record.time}: ${userId ?? "<NO UID>"}: ${record.message}',
      );
      }
    });
  }

  final logger = Logger('Tapped');
  String? userId;

  void setUserIdentifier(String? userId, { UserModel?  user }) {
    this.userId = userId;
    if (userId == null) {
      FirebaseCrashlytics.instance.setUserIdentifier('');
      Posthog().reset();
      return;
    }

    FirebaseCrashlytics.instance.setUserIdentifier(userId);
    if (user != null) {
      Posthog().identify(
        userId: userId,
        userProperties: {
          'email': user.email,
          'displayName': user.displayName,
          'username': user.username,
        },
      );
    } else {
      Posthog().identify(
        userId: userId,
      );
    }
  }

  Future<void> reportPreviousSessionErrors() async {
    final crashed =
        await FirebaseCrashlytics.instance.didCrashOnPreviousExecution();
    if (crashed) {
      warning('App crashed on previous execution');
    } else {
      debug('App did not crash on previous execution');
    }
  }

  void d(String message) {
    debug(message);
  }
  void debug(String message) {
    logger.fine(message);
  }

  void i(String message) {
    info(message);
  }
  void info(String message) {
    logger.info(message);
  }

  void w(String message) {
    warning(message);
  }
  void warning(String message) {
    logger.warning(message);
  }

  void e(String message, {Object? error, StackTrace? stackTrace}) {
    this.error(message, error: error, stackTrace: stackTrace);
  }
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    logger.severe(message, error, stackTrace);
    try {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: fatal);
    } catch (e, s) {
      logger.severe(
        'Failed to report error to Firebase Crashlytics',
        e,
        s,
      );
    }
  }

  Future<void> logAnalyticsEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Trace createTrace(String name) {
    debug('create trace: $name');
    return FirebasePerformance.instance.newTrace(name);
  }
}
