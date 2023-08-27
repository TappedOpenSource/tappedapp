abstract class AIRepository {
  Future<(String, String)> createAvatarInferenceJob({
    required String modelId,
    required String aesthetic,
  });
  Future<InferenceJob> getAvatarInferenceJob({
    required String inferenceId,
  });
  // Future<String> createAlbumName(
  //   String currentUserId,
  // );
}

class InferenceJob {
  InferenceJob({
    required this.id,
    required this.createdAt,
    required this.prompt,
    required this.seed,
    required this.width,
    required this.height,
    required this.numberOfImages,
    required this.state,
    required this.steps,
    required this.images,
    required this.modelId,
  });

  factory InferenceJob.fromResponse(Map<Object?, dynamic> job) {
    final images = job['images'] as List<dynamic>? ?? [];
    final modelId = job['modelId'] as String?;

    return InferenceJob(
      id: job['id'] as String?,
      createdAt: job['createdAt'] as String?,
      prompt: job['prompt'] as String?,
      seed: job['seed'] as int?,
      width: job['width'] as int?,
      height: job['height'] as int?,
      numberOfImages: job['numberOfImages'] as int?,
      state: job['state'] as String?,
      steps: job['steps'] as int?,
      images: images
          .map(
            (e) => ImageSchema(
              id: e['id'] as String?,
              uri: e['uri'] as String?,
              createdAt: e['createdAt'] as String?,
            ),
          )
          .toList(),
      modelId: modelId,
    );
  }

  final String? id;
  final String? createdAt;
  final String? prompt;
  final int? seed;
  final int? width;
  final int? height;
  final int? numberOfImages;
  final String? state; // "queued" | "failed" | "finished" | "processing";
  final int? steps;
  final List<ImageSchema>? images;
  final String? modelId;

  @override
  String toString() {
    return '''
InferenceJob(
      id: $id, 
      createdAt: $createdAt, 
      prompt: $prompt, 
      seed: $seed, 
      width: $width, 
      height: $height, 
      numberOfImages: $numberOfImages,
      state: $state, 
      steps: $steps, 
      images: $images, 
      modelId: $modelId,
      )
      ''';
  }
}

class ImageSchema {
  ImageSchema({
    required this.id,
    required this.uri,
    required this.createdAt,
  });

  final String? id;
  final String? uri;
  final String? createdAt;
}
