part of 'subscription_bloc.dart';

@immutable
abstract class SubscriptionState {}

class Uninitialized extends SubscriptionState {}

class Initialized extends SubscriptionState {
  Initialized({
    required this.subscribed,
  });

  final bool subscribed;
}

