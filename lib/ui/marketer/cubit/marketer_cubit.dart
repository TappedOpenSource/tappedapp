import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/marketing_plan.dart';

part 'marketer_state.dart';

class MarketerCubit extends Cubit<MarketerState> {
  MarketerCubit({
    required this.currentUserId,
    required this.database,
  }) : super(const MarketerState());

  final String currentUserId;
  final DatabaseRepository database;
  StreamSubscription<MarketingPlan>? marketingPlansSubscription;

  Future<void> initMarketingPlans() async {
    await marketingPlansSubscription?.cancel();
    marketingPlansSubscription =
        database.userMarketingPlansObserver(currentUserId).listen(
              (marketingPlan) => emit(
                state.copyWith(
                  marketingPlans: List.of(state.marketingPlans)
                    ..add(
                      marketingPlan,
                    )
                    ..sort(
                      (a, b) => b.timestamp.compareTo(a.timestamp),
                    ),
                ),
              ),
            );
  }

  Future<void> fetchMarketingPlans() async {
    final marketingPlans = await database.getUserMarketingPlans(currentUserId);
    emit(state.copyWith(marketingPlans: marketingPlans));
  }
}
