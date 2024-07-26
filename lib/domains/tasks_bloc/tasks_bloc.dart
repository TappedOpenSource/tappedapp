import 'package:bloc/bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:meta/meta.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc({
    required this.onboardingBloc,
    required this.bookingsBloc,
  }) : super(TasksInitial()) {}

  final OnboardingBloc onboardingBloc;
  final BookingsBloc bookingsBloc;


  int get taskCount {
    return 0;
  }
}
