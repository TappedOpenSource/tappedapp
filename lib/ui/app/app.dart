import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/routes.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class App extends StatelessWidget {
  const App({
    required this.repositories,
    required this.blocs,
    required this.streamClient,
    super.key,
  });

  final List<RepositoryProvider<Object>> repositories;
  final List<BlocProvider> blocs;
  final StreamChatClient streamClient;

  static final _analytics = FirebaseAnalytics.instance;
  static final _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en-US');

    return MultiRepositoryProvider(
      providers: repositories,
      child: MultiBlocProvider(
        providers: blocs,
        child: BlocBuilder<AppThemeCubit, bool>(
          builder: (context, isDarkSnapshot) {
            final appTheme =
                isDarkSnapshot ? Themes.themeDark : Themes.themeLight;
            final defaultStreamTheme = StreamChatThemeData.fromTheme(appTheme);
            final streamTheme = defaultStreamTheme;

            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Tapped',
              theme: appTheme,
              routerConfig: buildRoutes(
                observer: _observer,
              ),
              builder: (context, widget) {
                try {
                  return StreamChat(
                    client: streamClient,
                    streamChatThemeData: streamTheme,
                    child: widget,
                  );
                } catch (e, s) {
                  FirebaseCrashlytics.instance.recordError(e, s);
                  return widget ?? Container();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
