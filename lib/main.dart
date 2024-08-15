import 'dart:async';

import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/dependencies.dart';
import 'package:intheloopapp/firebase_options.dart';
import 'package:intheloopapp/ui/app/app.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/error.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await FMTCObjectBoxBackend().initialise();
  await const FMTCStore('mapStore').manage.create();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.debug('firebase app name: $app');
  await configureError();

  // Keep the app in portrait mode (no landscape)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FirebaseMessaging.onMessage.listen(
    _firebaseOnMessageHandler,
  );
  FirebaseMessaging.onMessageOpenedApp.listen(
    _firebaseOnMessageAppOpenHandler,
  );
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  final client = StreamChatClient('xyk6dwdsp422');
  // StreamVideo.init('xyk6dwdsp422');
  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    BetterFeedback(
      child: App(
        repositories: buildRepositories(streamChatClient: client),
        blocs: buildBlocs(
          navigatorKey: navigatorKey,
        ),
        streamClient: client,
        navigatorKey: navigatorKey,
      ),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background,
  // such as Firestore, make sure you call
  // `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messageData = message.data;
  logger.info('onMessageBackground $messageData');
}

Future<void> _firebaseOnMessageHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background,
  // such as Firestore, make sure you call
  // `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messageData = message.data;
  logger.info('onMessage $messageData');
}

Future<void> _firebaseOnMessageAppOpenHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background,
  // such as Firestore, make sure you call
  // `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messageData = message.data;
  logger.info('onMessageAppOpen $messageData');

  final url = messageData['url'] as String?;

  if (url != null) {
    final uri = Uri.parse(url);
    await launchUrl(uri);
  }
}
