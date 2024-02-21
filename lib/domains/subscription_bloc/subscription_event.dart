part of 'subscription_bloc.dart';

@immutable
abstract class SubscriptionEvent {}

class CheckSubscriptionStatus extends SubscriptionEvent {
  CheckSubscriptionStatus({
    required this.userId,
  });

  final String userId;
}

class UpdateSubscription extends SubscriptionEvent {
  UpdateSubscription({
    required this.customerInfo,
  });

  final CustomerInfo customerInfo;
}
