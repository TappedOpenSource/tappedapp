part of 'tasks_bloc.dart';

@immutable
sealed class TasksState {}

final class TasksInitial extends TasksState {

  int get taskCount => 0;
}
