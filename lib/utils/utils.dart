import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 5),
    ),
  );
}

Future<Uint8List?> pickImage() async {
  FilePickerResult? pickedImage = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: false,
  );

  if (pickedImage == null) {
    return null;
  }

  if (kIsWeb) {
    return pickedImage.files.single.bytes;
  }

  return await File(pickedImage.files.single.path!).readAsBytes();
}
