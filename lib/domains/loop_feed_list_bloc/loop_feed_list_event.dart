part of 'loop_feed_list_bloc.dart';

abstract class LoopFeedListEvent extends Equatable {
  const LoopFeedListEvent();

  @override
  List<Object> get props => [];
}

class ScrollToTop extends LoopFeedListEvent {}

class ChangeFeed extends LoopFeedListEvent {
  const ChangeFeed({
    required this.feed,
  });

  final LoopFeed feed;

  @override
  List<Object> get props => [feed];
}
