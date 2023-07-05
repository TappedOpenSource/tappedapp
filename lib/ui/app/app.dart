import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/notification_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/down_for_maintenance_bloc/down_for_maintenance_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/common/down_for_maintenance_view.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_view.dart';
import 'package:intheloopapp/ui/shell/shell_view.dart';
import 'package:intheloopapp/ui/splash/splash_view.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class App extends StatelessWidget {
  const App({
    required this.repositories,
    required this.blocs,
    required this.streamClient,
    required this.navigatorKey,
    super.key,
  });

  final List<RepositoryProvider<Object>> repositories;
  final List<BlocProvider> blocs;
  final StreamChatClient streamClient;
  final GlobalKey<NavigatorState> navigatorKey;

  static final _analytics = FirebaseAnalytics.instance;
  static final _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  Widget _authenticated(
    BuildContext context,
    String currentAuthUserId,
  ) {
    context.read<OnboardingBloc>().add(
          OnboardingCheck(
            userId: currentAuthUserId,
          ),
        );
    context.read<StreamRepository>().connectUser(currentAuthUserId);
    context.read<ActivityBloc>().add(InitListenerEvent());
    context.read<BookingsBloc>().add(FetchBookings());

    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, onboardState) {
        return switch (onboardState) {
          Onboarded() => () {
              context.read<NotificationRepository>().saveDeviceToken(
                    userId: currentAuthUserId,
                  );

              return const ShellView();
            }(),
          Onboarding() => const OnboardingView(),
          Unonboarded() => const LoadingView(),
        };
      },
    );
  }

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

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Tapped',
              theme: appTheme,
              navigatorObservers: <NavigatorObserver>[_observer],
              navigatorKey: navigatorKey,
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
              home:
                  BlocBuilder<DownForMaintenanceBloc, DownForMaintenanceState>(
                builder: (context, downState) {
                  return const SplashView();
                  // return const OnboardingView();

                  if (downState.downForMaintenance) {
                    return const DownForMainenanceView();
                  }

                  return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder:
                        (BuildContext context, AuthenticationState authState) {
                      try {
                        return switch (authState) {
                          Uninitialized() => const LoadingView(),
                          Authenticated() => _authenticated(
                              context,
                              authState.currentAuthUser.uid,
                            ),
                          Unauthenticated() => const SplashView(),
                        };
                      } catch (e, s) {
                        FirebaseCrashlytics.instance.recordError(
                          e,
                          s,
                          fatal: true,
                        );
                        return const LoadingView();
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
