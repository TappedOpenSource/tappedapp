
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<File> writeToFile(Uint8List rawPng) async {
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/feedback.png');
  await file.writeAsBytes(rawPng);
  return file;
}
