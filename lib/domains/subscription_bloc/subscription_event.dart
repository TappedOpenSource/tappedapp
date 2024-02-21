part of 'subscription_bloc.dart';

@immutable
abstract class SubscriptionEvent {}

class CheckSubscriptionStatus extends SubscriptionEvent {
  CheckSubscriptionStatus({required this.userId});

  final String userId;
}

class UpdateSubscriptionStatus extends SubscriptionEvent {
  UpdateSubscriptionStatus({required this.userId, required this.hasSubscription});

  final String userId;
  final bool hasSubscription;
}
