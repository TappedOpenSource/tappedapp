part of 'deep_link_bloc.dart';

abstract class DeepLinkEvent extends Equatable {
  const DeepLinkEvent();
}

class MonitorDeepLinks extends DeepLinkEvent {
  @override
  List<Object> get props => [];
}
