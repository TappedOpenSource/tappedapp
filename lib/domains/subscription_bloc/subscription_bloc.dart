import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<SubscriptionEvent>((event, emit) {
      // TODO:implement event handler
    });
  }
}
