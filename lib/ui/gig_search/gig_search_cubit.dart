import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/genre.dart';

part 'gig_search_state.dart';

class GigSearchCubit extends Cubit<GigSearchState> {
  GigSearchCubit() : super(const GigSearchState());
}
