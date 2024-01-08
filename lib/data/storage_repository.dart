import 'dart:io';
import 'dart:typed_data';

abstract class StorageRepository {
  Future<String> uploadProfilePicture(
    String userId,
    File imageFile,
  );
  Future<File> compressImage(String photoId, File image);
  Future<String> uploadAudioAttachment(File audioFile);
  Future<String> uploadImageAttachment(File imageFile);
  Future<String> uploadBadgeImage(String receiverId, File imageFile);
  Future<String> uploadAvatar({
    required String userId,
    required String originUrl,
  });
  Future<String> uploadOpportunityFlier({
    required String opportunityId,
    required File imageFile,
  });
  Future<String> uploadFeedbackScreenshot(
    String userId,
    Uint8List rawPng,
  );
}
