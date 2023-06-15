import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage({
    required String childName,
    required Uint8List file,
    required String uid,
  }) async {
    final Reference reference = _storage.ref().child(childName).child(uid);

    final UploadTask uploadTask = reference.putData(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
