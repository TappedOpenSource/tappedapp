import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'gig_search_state.dart';
part 'gig_search_cubit.freezed.dart';

class GigSearchCubit extends Cubit<GigSearchState> {
  GigSearchCubit() : super(const GigSearchState());

  void resetForm() {
    emit(
      state.copyWith(
        formStatus: FormzSubmissionStatus.initial,
      ),
    );
  }

  void updateLocation(Option<PlaceData> placeData) {
    emit(
      state.copyWith(
        place: placeData,
      ),
    );
  }

  void updateGenres(List<Genre> genres) {
    emit(
      state.copyWith(
        genres: genres,
      ),
    );
  }

  Future<void> searchVenues() async {
    emit(
      state.copyWith(
        formStatus: FormzSubmissionStatus.inProgress,
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    emit(
      state.copyWith(
        formStatus: FormzSubmissionStatus.success,
      ),
    );
  }
}
