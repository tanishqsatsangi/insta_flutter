import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String userName;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  Post({
    required this.description,
    required this.uid,
    required this.userName,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'userName': userName,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profileImage': profileImage,
        'likes': likes,
      };

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
      userName: snap['username'],
      uid: snap['uid'],
      description: snap['description'],
      postId: snap['postId'],
      postUrl: snap['postUrl'],
      profileImage: snap['profielImage'],
      likes: snap['likes'],
      datePublished: snap['datePublished'],
    );
  }
}
