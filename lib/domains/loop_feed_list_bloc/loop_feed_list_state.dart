part of 'loop_feed_list_bloc.dart';

class LoopFeedListState extends Equatable {
  const LoopFeedListState({
    required this.feed,
    required this.feedParamsList,
  });

  final Map<LoopFeed, FeedParams> feedParamsList;
  final LoopFeed feed;

  @override
  List<Object> get props => [
        feed,
        feedParamsList,
      ];

  LoopFeedListState copyWith({
    LoopFeed? feed,
    Map<LoopFeed, FeedParams>? feedParamsList,
  }) {
    return LoopFeedListState(
      feed: feed ?? this.feed,
      feedParamsList: feedParamsList ?? this.feedParamsList,
    );
  }
}

class FeedParams {
  FeedParams({
    required this.sourceFunction,
    required this.sourceStream,
    required this.label,
    required this.scrollController,
  });

  final String label;
  final ScrollController scrollController;
  final Future<List<Loop>> Function(
    String currentUserId, {
    int limit,
    String? lastLoopId,
    bool ignoreCache,
  }) sourceFunction;
  final Stream<Loop> Function(
    String currentUserId, {
    int limit,
    bool ignoreCache,
  }) sourceStream;
}

enum LoopFeed {
  following,
  forYou,
}
