part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
}

class Pop extends NavigationEvent {
  const Pop();

  @override
  String toString() => 'Pop { }';

  @override
  List<Object> get props => [];
}

class Push extends NavigationEvent {
  const Push(
    this.route,
  );

  final TappedRoute route;

  @override
  String toString() => 'Push { route: $route }';

  @override
  List<Object> get props => [route];
}

class ChangeTab extends NavigationEvent {
  const ChangeTab({required this.selectedTab});

  final int selectedTab;

  @override
  String toString() => 'ChangeTab { selectedTab: $selectedTab }';

  @override
  List<Object> get props => [selectedTab];
}
