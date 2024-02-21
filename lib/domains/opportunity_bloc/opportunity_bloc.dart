import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart'
    hide Uninitialized;
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/subscription_bloc/subscription_bloc.dart';

part 'opportunity_event.dart';

part 'opportunity_state.dart';

final _analytics = FirebaseAnalytics.instance;

class OpportunityBloc extends Bloc<OpportunityEvent, OpportunityState> {
  OpportunityBloc({
    required this.nav,
    required this.auth,
    required this.authBloc,
    required this.subscriptionBloc,
    required this.database,
  }) : super(const OpportunityState()) {
    on<InitQuotaListener>((event, emit) {
      final currentUserId =
          (authBloc.state as Authenticated).currentAuthUser.uid;
      _quotaSubscription = database
          .getUserOpportunityQuotaObserver(currentUserId)
          .listen((event) {
        add(SetQuota(quota: event));
      });
    });
    on<SetQuota>((event, emit) {
      final quota = event.quota;
      emit(
        state.copyWith(opQuota: quota),
      );
    });
    on<DislikeOpportunity>((event, emit) async {
      final currentUserId =
          (authBloc.state as Authenticated).currentAuthUser.uid;
      final op = event.opportunity;
      await database.dislikeOpportunity(
        opportunity: op,
        userId: currentUserId,
      );
    });
    on<ApplyForOpportunity>((event, emit) async {
      final currentUserId =
          (authBloc.state as Authenticated).currentAuthUser.uid;
      final userComment = event.userComment;
      final op = event.opportunity;

      // check credits
      if (state.opQuota == 0) {
        await _analytics.logEvent(
          name: 'quota_limit_hit',
          parameters: {
            'user_id': currentUserId,
            'opportunity_id': op.id,
          },
        );
        nav.push(PaywallPage());
        return;
      }

      await database.applyForOpportunity(
        opportunity: op,
        userId: currentUserId,
        userComment: userComment,
      );

      return switch (subscriptionBloc.state) {
        Initialized(:final subscribed) => (() {
            if (!subscribed) {
              database.decrementUserOpportunityQuota(currentUserId);
            }
          })(),
        _ => database.decrementUserOpportunityQuota(currentUserId),
      };
    });
  }

  @override
  Future<void> close() {
    _quotaSubscription?.cancel();
    return super.close();
  }

  final DatabaseRepository database;
  final AuthRepository auth;
  final AuthenticationBloc authBloc;
  final SubscriptionBloc subscriptionBloc;
  final NavigationBloc nav;
  StreamSubscription<int?>? _quotaSubscription;
}
