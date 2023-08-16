part of 'uni_link_bloc.dart';

abstract class UniLinkEvent extends Equatable {
  const UniLinkEvent();
}

class MonitorUniLinks extends UniLinkEvent {
  @override
  List<Object> get props => [];
}
