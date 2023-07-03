import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/dependencies.dart';
import 'package:intheloopapp/utils/error.dart';
import 'package:intheloopapp/firebase_options.dart';
import 'package:intheloopapp/ui/app/app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await configureError();

  // Keep the app in portrait mode (no landscape)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  final client = StreamChatClient('xyk6dwdsp422');
  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    App(
      repositories: buildRepositories(streamChatClient: client),
      blocs: buildBlocs(
        navigatorKey: navigatorKey,
      ),
      streamClient: client,
      navigatorKey: navigatorKey,
    ),
  );
}

/// The root widget for the app

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background,
  // such as Firestore, make sure you call
  // `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // print(message.data);
}
