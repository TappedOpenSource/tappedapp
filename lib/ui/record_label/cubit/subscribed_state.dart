part of 'subscribed_cubit.dart';

class SubscribedState extends Equatable {
  const SubscribedState({
    this.avatars = const [],
  });

  final List<Avatar> avatars;

  @override
  List<Object> get props => [avatars];

  SubscribedState copyWith({
    List<Avatar>? avatars,
  }) {
    return SubscribedState(
      avatars: avatars ?? this.avatars,
    );
  }
}
