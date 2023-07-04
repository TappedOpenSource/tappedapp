import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/notification_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/down_for_maintenance_bloc/down_for_maintenance_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/common/down_for_maintenance_view.dart';
import 'package:intheloopapp/ui/error/error_view.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/login/login_view.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_view.dart';
import 'package:intheloopapp/ui/profile/profile_view.dart';
import 'package:intheloopapp/ui/shell/shell_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter buildRoutes({
  required NavigatorObserver observer,
}) {
  return GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      _buildShellRoute(),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: '/error',
        builder: (context, state) => const ErrorView(),
      ),
      GoRoute(
        path: '/down_for_maintenance',
        builder: (context, state) => const DownForMainenanceView(),
      ),
      GoRoute(
        path: '/:userId',
        builder: (context, state) => ProfileView(
          visitedUserId: 'userId',
          visitedUser: const None<UserModel>(),
        ),
      ),
    ],
    errorPageBuilder: (BuildContext context, GoRouterState state) {
      return MaterialPage<ErrorView>(
        key: state.pageKey,
        child: const ErrorView(),
      );
    },
    redirect: (context, state) {
      final loginLocation = state.namedLocation(APP_PAGE.login.toPath);
      final homeLocation = state.namedLocation(APP_PAGE.home.toPath);
      final splashLocation = state.namedLocation(APP_PAGE.splash.toPath);
      final onboardLocation = state.namedLocation(APP_PAGE.onBoarding.toPath);

      final isLogedIn = appService.loginState;
      final isInitialized = appService.initialized;
      final isOnboarded = appService.onboarding;

      final isGoingToLogin = state.subloc == loginLocation;
      final isGoingToInit = state.subloc == splashLocation;
      final isGoingToOnboard = state.subloc == onboardLocation;


      final downState = context.read<DownForMaintenanceBloc>().state;
      if (downState.downForMaintenance) {
        return '/down_for_maintenance';
      }

      final authState = context.read<AuthenticationBloc>().state;
      try {
        return switch (authState) {
          Uninitialized() => '/loading',
          Authenticated() => _authenticated(
              context,
              authState.currentAuthUser.uid,
            ).asNullable(),
          Unauthenticated() => '/login',
        };
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          fatal: true,
        );
        return '/loading';
      }
    },
    observers: [observer],
  );
}

ShellRoute _buildShellRoute() {
  return ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) => ShellView(
      child: child,
    ),
    routes: [
      GoRoute(
        path: '/feed',
        builder: (context, state) => const LoadingView(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const LoadingView(),
      ),
      GoRoute(
        path: '/bookings',
        builder: (context, state) => const LoadingView(),
      ),
      GoRoute(
        path: '/:userId',
        builder: (context, state) => const LoadingView(),
      ),
    ],
  );
}

Option<String> _authenticated(
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

  final onboardState = context.read<OnboardingBloc>().state;

  return switch (onboardState) {
    Onboarded() => () {
        context.read<NotificationRepository>().saveDeviceToken(
              userId: currentAuthUserId,
            );

        return const None<String>();
      }(),
    Onboarding() => const Some('/onboarding'),
    Unonboarded() => const Some('/loading'),
  };
}
