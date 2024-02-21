import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/notification_repository.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/remote_config_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/domains/opportunity_bloc/opportunity_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/domains/subscription_bloc/subscription_bloc.dart';

extension BlocUtils on BuildContext {
  DatabaseRepository get database => read<DatabaseRepository>();
  AuthRepository get auth => read<AuthRepository>();
  StorageRepository get storage => read<StorageRepository>();
  PlacesRepository get places => read<PlacesRepository>();
  PaymentRepository get payments => read<PaymentRepository>();
  RemoteConfigRepository get remoteConfig => read<RemoteConfigRepository>();
  StreamRepository get stream => read<StreamRepository>();
  NotificationRepository get notifications => read<NotificationRepository>();
  RemoteConfigRepository get remote => read<RemoteConfigRepository>();

  NavigationBloc get nav => read<NavigationBloc>();
  AuthenticationBloc get authentication => read<AuthenticationBloc>();
  OnboardingBloc get onboarding => read<OnboardingBloc>();
  BookingsBloc get bookings => read<BookingsBloc>();
  OpportunityBloc get opportunities => read<OpportunityBloc>();
  SearchBloc get search => read<SearchBloc>();
  SubscriptionBloc get subscriptions => read<SubscriptionBloc>();
}
