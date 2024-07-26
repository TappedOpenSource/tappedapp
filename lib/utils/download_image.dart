import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:path_provider/path_provider.dart';

final dio = Dio();

Future<Option<File>> downloadImage(String url) async {
  try {
  // Fetch the image from the URL
  final response = await dio.get<List<int>>(
    url,
    options: Options(responseType: ResponseType.bytes),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to download image');
  }

    // Get the temporary directory path
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    // Create a file path for the image
    final file = File('$tempPath/temp_image.jpg');

    // Write the image bytes to the file
    final data = response.data;
    if (data == null) {
      throw Exception('Failed to download image');
    }

    await file.writeAsBytes(data);

    return Option.of(file);
  } catch (e, s) {
    logger.e('Failed to download image', error: e, stackTrace: s);
    return const None();
  }
}