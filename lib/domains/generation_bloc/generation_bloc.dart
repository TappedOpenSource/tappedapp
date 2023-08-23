import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/ai_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'generation_event.dart';
part 'generation_state.dart';

class GenerationBloc extends Bloc<GenerationEvent, GenerationState> {
  GenerationBloc({
    required this.authenticationBloc,
    required this.database,
    required this.ai,
  }) : super(const GenerationState()) {
    on<SelectAesthetic>((event, emit) {
      emit(
        state.copyWith(
          selectedAesthetic: Some(event.aesthetic),
        ),
      );
    });
    on<GenerateAvatar>((event, emit) async {
      return switch (state.selectedAesthetic) {
        None() => null,
        Some(:final value) => () async {
            logger.info(
              'generating avatar for aesthetic: ${event.aesthetic}',
            );
            emit(state.copyWith(loading: true));
            final currentUserId =
                (authenticationBloc.state as Authenticated).currentAuthUser.uid;

            final userImageModel =
                await database.getUserImageModel(currentUserId);
            if (userImageModel == null) {
              logger.error('userImageModel is null');
              return;
            }

            // create inference job
            final (inferenceId, prompt) = await ai.createAvatarInferenceJob(
              modelId: userImageModel.id,
              aesthetic: value,
            );
            logger.debug('inferenceId: $inferenceId, prompt: $prompt');

            await pollInferenceJobTillComplete(inferenceId, emit);
          }(),
      };
    });
    on<ResetGeneration>((event, emit) {
      emit(const GenerationState());
    });
  }

  final AuthenticationBloc authenticationBloc;
  final DatabaseRepository database;
  final AIRepository ai;

  Future<void> pollInferenceJobTillComplete(
    String inferenceId,
    Emitter<GenerationState> emit,
  ) async {
// get inference job
    final inferenceJob = await ai.getAvatarInferenceJob(
      inferenceId: inferenceId,
    );

    if (inferenceJob.state == 'failed') {
      logger.error('inferenceJob failed');
      throw Exception('inferenceJob failed');
    }

    if (inferenceJob.state == 'queued') {
      logger.debug('inferenceJob queued');
      await Future.delayed(const Duration(milliseconds: 200));
      await pollInferenceJobTillComplete(inferenceId, emit);
      return;
    }

    if (inferenceJob.state == 'processing') {
      logger.debug('inferenceJob processing');
      await Future.delayed(const Duration(milliseconds: 200));
      await pollInferenceJobTillComplete(inferenceId, emit);
      return;
    }

    // save inferenceId and prompt to database
    // await Future.wait(
    //   imageUrls.map((String url) async {
    //     final newImageUrl = await storage.uploadAvatar(url);
    //     final uuid = const Uuid().v4();
    //     final avatar = Avatar(
    //       id: uuid,
    //       userId: currentUserId,
    //       prompt: prompt,
    //       imageUrl: newImageUrl,
    //       inferenceId: inferenceId,
    //     );
    //     await database.createAvatar(avatar);
    //   }),
    // );
    logger.info('$inferenceJob');
    final imageUrls = inferenceJob.images?.map((image) => image.uri).toList();

    logger.debug('imageUrls: $imageUrls');
    emit(
      state.copyWith(
        imageUrls: Option.fromNullable(imageUrls?.whereType<String>().toList()),
        loading: false,
      ),
    );
  }
}
