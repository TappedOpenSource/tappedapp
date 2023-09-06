import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/ai_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/models/avatar.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:uuid/uuid.dart';

part 'generation_event.dart';
part 'generation_state.dart';

const avatarCreditCost = 5;

class GenerationBloc extends Bloc<GenerationEvent, GenerationState> {
  GenerationBloc({
    required this.onboardingBloc,
    required this.database,
    required this.storage,
    required this.ai,
  }) : super(const GenerationState()) {
    on<SelectPrompt>((event, emit) {
      emit(
        state.copyWith(
          selectedPrompt: Some(event.prompt),
        ),
      );
    });
    on<GenerateAvatar>((event, emit) async {
      return switch (state.selectedPrompt) {
        None() => null,
        Some(:final value) => () async {
            logger.info(
              'generating avatar for aesthetic: ${event.prompt}',
            );
            emit(state.copyWith(loading: true));
            final currentUser = (onboardingBloc.state as Onboarded).currentUser;

            onboardingBloc.add(
              UpdateOnboardedUser(
                user: currentUser.copyWith(
                  aiCredits: currentUser.aiCredits - avatarCreditCost,
                ),
              ),
            );

            final userImageModel =
                await database.getUserImageModel(currentUser.id);

            if (userImageModel.isNone) {
              logger.error('userImageModel is null');
              return;
            }

            // create inference job
            final (inferenceId, prompt) = await ai.createAvatarInferenceJob(
              modelId: userImageModel.unwrap.id,
              prompt: value,
            );
            logger.debug('inferenceId: $inferenceId, prompt: $prompt');

            await pollInferenceJobTillComplete(
              inferenceId: inferenceId,
              prompt: prompt,
              currentUserId: currentUser.id,
              emit: emit,
            );
          }(),
      };
    });
    on<SaveAvatar>((event, emit) async {
      final result = event.result;
      final currentUser = (onboardingBloc.state as Onboarded).currentUser;
      final newImageUrl = await storage.uploadAvatar(
        userId: currentUser.id,
        originUrl: result.imageUrl,
      );
      final uuid = const Uuid().v4();
      final avatar = Avatar(
        id: uuid,
        userId: currentUser.id,
        prompt: result.prompt,
        imageUrl: newImageUrl,
        inferenceId: result.inferenceId,
        timestamp: DateTime.now(),
      );
      await database.createAvatar(avatar);
      emit(const GenerationState());
    });
    on<ResetGeneration>((event, emit) {
      emit(const GenerationState());
    });
  }

  final OnboardingBloc onboardingBloc;
  final DatabaseRepository database;
  final AIRepository ai;
  final StorageRepository storage;

  Future<void> pollInferenceJobTillComplete({
    required String inferenceId,
    required String prompt,
    required String currentUserId,
    required Emitter<GenerationState> emit,
  }) async {
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
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await pollInferenceJobTillComplete(
        inferenceId: inferenceId,
        prompt: prompt,
        currentUserId: currentUserId,
        emit: emit,
      );
      return;
    }

    if (inferenceJob.state == 'processing') {
      logger.debug('inferenceJob processing');
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await pollInferenceJobTillComplete(
        inferenceId: inferenceId,
        prompt: prompt,
        currentUserId: currentUserId,
        emit: emit,
      );
      return;
    }

    logger.info('$inferenceJob');
    final results = inferenceJob.images
        ?.map(
          (image) => image.uri == null
              ? null
              : GenerationResult(
                  imageUrl: image.uri!,
                  inferenceId: inferenceId,
                  prompt: prompt,
                ),
        )
        .toList();

    logger.debug('results: $results');
    emit(
      state.copyWith(
        results: Option.fromNullable(
          results?.whereType<GenerationResult>().toList(),
        ),
        loading: false,
      ),
    );
  }
}
