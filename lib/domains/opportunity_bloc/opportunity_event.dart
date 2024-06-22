part of 'opportunity_bloc.dart';

sealed class OpportunityEvent extends Equatable {
  const OpportunityEvent();

  @override
  List<Object> get props => [];
}

final class InitQuotaListener extends OpportunityEvent {
  const InitQuotaListener();
}

final class SetQuota extends OpportunityEvent {
  const SetQuota({required this.quota});

  final int quota;

  @override
  List<Object> get props => [quota];
}

final class DislikeOpportunity extends OpportunityEvent {
  const DislikeOpportunity({
    required this.opportunity,
  });

  final Opportunity opportunity;

  @override
  List<Object> get props => [
    opportunity,
  ];
}

final class ApplyForOpportunity extends OpportunityEvent {
  const ApplyForOpportunity({
    required this.opportunity,
    required this.userComment,
  });

  final Opportunity opportunity;
  final String userComment;

  @override
  List<Object> get props => [
        opportunity,
        userComment,
      ];
}

final class BatchApplyForOpportunities extends OpportunityEvent {
  const BatchApplyForOpportunities({
    required this.opportunities,
    required this.userComment,
  });

  final List<Opportunity> opportunities;
  final String userComment;

  @override
  List<Object> get props => [
    opportunities,
    userComment,
  ];
}
