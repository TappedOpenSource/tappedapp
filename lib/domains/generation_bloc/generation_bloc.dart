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
      await Future.delayed(const Duration(milliseconds: 500));
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
      await Future.delayed(const Duration(milliseconds: 500));
      await pollInferenceJobTillComplete(
        inferenceId: inferenceId,
        prompt: prompt,
        currentUserId: currentUserId,
        emit: emit,
      );
      return;
    }

    logger.info('$inferenceJob');
    final imageUrls = inferenceJob.images?.map((image) => image.uri).toList();

    // save inferenceId and prompt to database
    if (imageUrls == null) {
      logger.error('imageUrls is null');
      throw Exception('imageUrls is null');
    }

    await Future.wait(
      imageUrls.map(
        (String? url) async {
          if (url == null) {
            return;
          }

          final newImageUrl = await storage.uploadAvatar(
            userId: currentUserId,
            originUrl: url,
          );
          final uuid = const Uuid().v4();
          final avatar = Avatar(
            id: uuid,
            userId: currentUserId,
            prompt: prompt,
            imageUrl: newImageUrl,
            inferenceId: inferenceId,
            timestamp: DateTime.now(),
          );
          await database.createAvatar(avatar);
        },
      ),
    );

    logger.debug('imageUrls: $imageUrls');
    emit(
      state.copyWith(
        imageUrls: Option.fromNullable(imageUrls.whereType<String>().toList()),
        loading: false,
      ),
    );
  }
}
