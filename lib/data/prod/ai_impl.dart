import 'package:cloud_functions/cloud_functions.dart';
import 'package:intheloopapp/data/ai_repository.dart';
import 'package:intheloopapp/domains/models/marketing_plan.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:path/path.dart';

final _functions = FirebaseFunctions.instance;

class AiImpl implements AIRepository {
  @override
  Future<(String, String)> createAvatarInferenceJob({
    required String modelId,
    required String prompt,
  }) async {
    final callable = _functions.httpsCallable('createAvatarInferenceJob');

    final results = await callable<Map<String, dynamic>>({
      'modelId': modelId,
      'prompt': prompt,
    });
    final data = results.data;
    final inferenceId = data['inferenceId'] as String?;

    if (inferenceId == null) {
      throw Exception('inferenceId or prompt is null');
    }

    return (inferenceId, prompt);
  }

  @override
  Future<InferenceJob> getAvatarInferenceJob({
    required String inferenceId,
  }) async {
    final callable = _functions.httpsCallable('getAvatarInferenceJob');
    final results = await callable<Map<String, dynamic>>({
      'inferenceId': inferenceId,
    });

    logger.info('getAvatarInferenceJob: ${results.data}');

    final data = results.data;

    final job = InferenceJob.fromResponse(
      data['inferenceJob'] as Map<Object?, dynamic>? ?? {},
    );

    return job;
  }

  @override
  Future<MarketingPlan> createMarketingPlan(
    String currentUserId,
  ) async {
    return MarketingPlan(
      id: '1',
      userId: currentUserId,
      type: MarketingPlanType.single,
      content: 'content',
      timestamp: DateTime.now(),
    );
  }
}
