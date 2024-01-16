import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/deep_link_repository.dart';
import 'package:intheloopapp/data/image_picker_repository.dart';
import 'package:intheloopapp/data/notification_repository.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/prod/algolia_search_impl.dart';
import 'package:intheloopapp/data/prod/audio_service_impl.dart';
import 'package:intheloopapp/data/prod/cloud_messaging_impl.dart';
import 'package:intheloopapp/data/prod/firebase_auth_impl.dart';
import 'package:intheloopapp/data/prod/firebase_dynamic_link_impl.dart';
import 'package:intheloopapp/data/prod/firebase_storage_impl.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/data/prod/google_places_impl.dart';
import 'package:intheloopapp/data/prod/image_picker_impl.dart';
import 'package:intheloopapp/data/prod/remote_config_impl.dart';
import 'package:intheloopapp/data/prod/stream_impl.dart';
import 'package:intheloopapp/data/prod/stripe_payment_impl.dart';
import 'package:intheloopapp/data/prod/uni_link_impl.dart';
import 'package:intheloopapp/data/remote_config_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/confirm_email_bloc/confirm_email_bloc.dart';
import 'package:intheloopapp/domains/deep_link_bloc/deep_link_bloc.dart';
import 'package:intheloopapp/domains/down_for_maintenance_bloc/down_for_maintenance_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/domains/opportunity_bloc/opportunity_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/premium_theme_cubit.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// link all necessary repository interfaces
/// with their respective implementations
List<RepositoryProvider<Object>> buildRepositories({
  required StreamChatClient streamChatClient,
}) {
  return [
    RepositoryProvider<AuthRepository>(
      create: (_) => FirebaseAuthImpl(),
    ),
    RepositoryProvider<DatabaseRepository>(
      create: (_) => FirestoreDatabaseImpl(),
    ),
    RepositoryProvider<StorageRepository>(
      create: (_) => FirebaseStorageImpl(),
    ),
    RepositoryProvider<ImagePickerRepository>(
      create: (_) => ImagePickerImpl(),
    ),
    RepositoryProvider<SearchRepository>(
      create: (_) => AlgoliaSearchImpl(
        applicationId: 'GCNFAI2WB6',
        apiKey: 'c89ebf37b46a3683405be3ed0901f217',
      ),
    ),
    RepositoryProvider<DeepLinkRepository>(
      create: (_) => UniLinkImpl(),
    ),
    RepositoryProvider<StreamRepository>(
      create: (_) => StreamImpl(streamChatClient),
    ),
    RepositoryProvider<NotificationRepository>(
      create: (_) => CloudMessagingImpl(streamChatClient),
    ),
    RepositoryProvider<RemoteConfigRepository>(
      create: (_) => RemoteConfigImpl()..fetchAndActivate(),
    ),
    RepositoryProvider<PaymentRepository>(
      create: (_) => StripePaymentImpl()..initPayments(),
    ),
    RepositoryProvider<PlacesRepository>(
      create: (_) => GooglePlacesImpl(),
    ),
    RepositoryProvider<AudioRepository>(
      create: (_) => AudioServiceImpl()..initAudioService(),
    ),
  ];
}

/// link all blocs with their respective interfaces
List<BlocProvider> buildBlocs({
  required GlobalKey<NavigatorState> navigatorKey,
}) {
  return [
    BlocProvider<AppThemeCubit>(
      create: (_) => AppThemeCubit(),
    ),
    BlocProvider<PremiumThemeCubit>(
      create: (_) => PremiumThemeCubit(),
    ),
    BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
        authRepository: context.auth,
      )..add(AppStarted()),
    ),
    BlocProvider<ConfirmEmailBloc>(
      create: (context) => ConfirmEmailBloc(
        authRepository: context.auth,
      ),
    ),
    BlocProvider<NavigationBloc>(
      create: (context) => NavigationBloc(
        database: context.database,
        navigationKey: navigatorKey,
      ),
    ),
    BlocProvider<OnboardingBloc>(
      create: (context) => OnboardingBloc(
        databaseRepository: context.database,
      ),
    ),
    BlocProvider<DeepLinkBloc>(
      //Depreciated
      create: (context) => DeepLinkBloc(
        onboardingBloc: context.onboarding,
        navBloc: context.nav,
        dynamicLinkRepository: context.read<DeepLinkRepository>(),
        databaseRepository: context.database,
      ),
    ),
    BlocProvider<DownForMaintenanceBloc>(
      create: (context) => DownForMaintenanceBloc(
        remoteConfigRepository: context.remoteConfig,
      )..add(CheckStatus()),
    ),
    BlocProvider<ActivityBloc>(
      create: (context) => ActivityBloc(
        databaseRepository: context.database,
        authenticationBloc: context.authentication,
      ),
    ),
    BlocProvider<BookingsBloc>(
      create: (context) => BookingsBloc(
        database: context.database,
        authenticationBloc: context.authentication,
      ),
    ),
    BlocProvider<OpportunityBloc>(
      create: (context) => OpportunityBloc(
        database: context.database,
        nav: context.nav,
        auth: context.auth,
        authBloc: context.authentication,
      ),
    ),
    BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        database: context.database,
        searchRepository: context.read<SearchRepository>(),
        places: context.places,
      ),
    ),
  ];
}
