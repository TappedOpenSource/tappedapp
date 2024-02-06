import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_to_perform_state.dart';
part 'request_to_perform_cubit.freezed.dart';

class RequestToPerformCubit extends Cubit<RequestToPerformState> {
  RequestToPerformCubit() : super(const RequestToPerformState());
}
