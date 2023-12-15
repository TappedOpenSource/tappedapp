part of 'opportunity_bloc.dart';

class OpportunityState extends Equatable {
  const OpportunityState({
    this.opQuota = 0,
  });

  final int opQuota;

  @override
  List<Object> get props => [
        opQuota,
      ];

  OpportunityState copyWith({
    int? opQuota,
  }) {
    return OpportunityState(
      opQuota: opQuota ?? this.opQuota,
    );
  }
}
