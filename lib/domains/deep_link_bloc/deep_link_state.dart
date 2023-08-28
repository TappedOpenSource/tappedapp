part of 'deep_link_bloc.dart';

abstract class DeepLinkState extends Equatable {
  const DeepLinkState();
}

class DeepLinkInitial extends DeepLinkState {
  @override
  List<Object> get props => [];
}
