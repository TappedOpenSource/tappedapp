part of 'opportunity_feed_cubit.dart';

class OpportunityFeedState extends Equatable {
  const OpportunityFeedState({
    this.loading = false,
    this.showApplyAnimation = false,
    this.opportunities = const [],
    this.curOp = 0,
  });

  final bool loading;
  final bool showApplyAnimation;
  final List<Opportunity> opportunities;
  final int curOp;

  @override
  List<Object> get props => [
        loading,
        showApplyAnimation,
        opportunities,
        curOp,
      ];

  OpportunityFeedState copyWith({
    bool? loading,
    bool? showApplyAnimation,
    List<Opportunity>? opportunities,
    int? curOp,
  }) {
    return OpportunityFeedState(
      loading: loading ?? this.loading,
      showApplyAnimation: showApplyAnimation ?? this.showApplyAnimation,
      opportunities: opportunities ?? this.opportunities,
      curOp: curOp ?? this.curOp,
    );
  }
}
