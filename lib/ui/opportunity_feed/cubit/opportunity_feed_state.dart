part of 'opportunity_feed_cubit.dart';

class OpportunityFeedState extends Equatable {
  const OpportunityFeedState({
    this.loading = false,
    this.opportunities = const [],
    this.curOp = 0,
  });

  final bool loading;
  final List<Opportunity> opportunities;
  final int curOp;

  @override
  List<Object> get props => [
        loading,
        opportunities,
        curOp,
      ];

  OpportunityFeedState copyWith({
    bool? loading,
    List<Opportunity>? opportunities,
    int? curOp,
  }) {
    return OpportunityFeedState(
      loading: loading ?? this.loading,
      opportunities: opportunities ?? this.opportunities,
      curOp: curOp ?? this.curOp,
    );
  }
}
