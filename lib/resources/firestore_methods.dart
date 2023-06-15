import 'dart:typed_data';

import 'package:clone_twitch/models/livestream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '/models/user.dart';
import '/utils/constants.dart';
import '/utils/utils.dart';

import '/providers/user_provider.dart';

import '/resources/storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();

  Future<String> startLiveStream({
    required BuildContext context,
    required String title,
    required Uint8List? image,
  }) async {
    try {
      final User user =
          Provider.of<UserProvider>(context, listen: false).getUser;

      if (user == null) {
        throw Exception('Please login first');
      }

      String channelId = '';
      if (title.isEmpty || image == null) {
        throw Exception('Please fill all the fields');
      }

      final DocumentSnapshot<Map<String, dynamic>> liveStreamSnapshot =
          await _firestore
              .collection(liveStreamsCollection)
              .doc(user.uid)
              .get();

      if (liveStreamSnapshot.exists) {
        throw Exception('You are already live streaming');
      }

      final String thumbnailUrl = await _storageMethods.uploadImageToStorage(
        childName: liveStreamsThumbnailCollection,
        file: image,
        uid: user.uid,
      );

      channelId = '${user.uid}${user.username}';

      final LiveStream liveStream = LiveStream(
        title: title,
        uid: user.uid,
        image: thumbnailUrl,
        username: user.username,
        startedAt: DateTime.now(),
        viewers: 0,
        channelId: channelId,
      );

      print('livestreamcollection: $liveStreamsCollection');
      print('channelId: $channelId');

      await _firestore
          .collection(liveStreamsCollection)
          .doc(channelId)
          .set(liveStream.toMap());

      return channelId;
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message ?? 'Something went wrong');
      return '';
    } catch (e) {
      showSnackBar(context, e.toString());
      return '';
    }
  }
}
