import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/models/comment.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/resources/storage_provider.dart';
import 'package:social_media_app/utils/strings.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, String uid, Uint8List file,
      String userName, String profileImage) async {
    String res = Strings.some_error_occured;
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        userName: userName,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  } // upload post

  likePost(
    String postId,
    String uidUser,
    List likes,
    bool isFromDoubleTap,
  ) async {
    try {
      if (likes.contains(uidUser) && !isFromDoubleTap) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uidUser]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uidUser]),
        });
      }
    } catch (exceptiin) {
      print(exceptiin.toString());
    }
  }

  likeComment(
    String postId,
    String commentId,
    String uidUser,
    List likes,
  ) async {
    try {
      if (likes.contains(uidUser)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uidUser]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uidUser]),
        });
      }
    } catch (exceptiin) {
      print(exceptiin.toString());
    }
  }

  Future<void> postComment(
    String postId,
    String uid,
    String comment,
    String userName,
    String profileImage,
  ) async {
    try {
      String commentId = const Uuid().v1();
      Comment commentModel = Comment(
        comment: comment,
        commentId: commentId,
        userName: userName,
        postId: postId,
        datePublished: DateTime.now(),
        profileImage: profileImage,
        likes: [],
      );
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(commentModel.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> deletePost(String postId) async {
    String res = Strings.some_error_occured;
    try {
      await _firestore.collection('posts').doc(postId).delete();

      res = 'Post deleted Successfully';
      return res;
    } catch (e) {
      print(e.toString());
      return res;
    }
  }

  Future<void> followUnFollowUser(String uid, String followId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      List following = snapshot['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
