import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/create_service/components/service_description.dart';
import 'package:intheloopapp/ui/create_service/components/service_title.dart';
import 'package:uuid/uuid.dart';

part 'create_service_state.dart';

class CreateServiceCubit extends Cubit<CreateServiceState> {
  CreateServiceCubit({
    required this.database,
    required this.nav,
    required this.ownerId,
  }) : super(const CreateServiceState());

  final DatabaseRepository database;
  final NavigationBloc nav;

  final String ownerId;

  void initFields(Option<Service> service) {
    if (service is Some<Service>) {
      emit(
        state.copyWith(
          title: ServiceTitle.dirty(service.value.title),
          description: ServiceDescription.dirty(service.value.description),
          rate: service.value.rate,
          rateType: service.value.rateType,
        ),
      );
    }
  }

  void onTitleChange(String title) => emit(
        state.copyWith(
          title: ServiceTitle.dirty(title.trim()),
        ),
      );

  void onDescriptionChange(String description) => emit(
        state.copyWith(
          description: ServiceDescription.dirty(description.trim()),
        ),
      );
  void onRateChange(int rate) => emit(
        state.copyWith(
          rate: rate,
        ),
      );
  void onRateTypeChange(RateType rateType) => emit(
        state.copyWith(
          rateType: rateType,
        ),
      );

  Future<void> edit(
    Service service,
    void Function(Service) onEdited,
  ) async {
    try {
      if (state.status.isInProgress) return;

      if (!state.isValid) {
        throw Exception('Invalid form');
      }

      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final newServie = service.copyWith(
        title: state.title.value,
        description: state.description.value,
        rate: state.rate,
        rateType: state.rateType,
      );
      await database.updateService(newServie);

      onEdited.call(newServie);

      emit(state.copyWith(status: FormzSubmissionStatus.success));

      nav.pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      rethrow;
    }
  }

  Future<void> create(void Function(Service) onCreated) async {
    // add validation
    try {
      if (state.status.isInProgress) return;

      if (!state.isValid) {
        throw Exception('Invalid form');
      }

      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final service = Service(
        id: const Uuid().v4(),
        userId: ownerId,
        title: state.title.value,
        description: state.description.value,
        rate: state.rate,
        rateType: state.rateType,
      );
      await database.createService(service);

      onCreated.call(service);

      emit(state.copyWith(status: FormzSubmissionStatus.success));

      nav.pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      rethrow;
    }
  }
}
