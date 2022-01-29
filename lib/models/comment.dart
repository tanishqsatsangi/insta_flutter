import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String comment;
  final String commentId;
  final String userName;
  final String postId;
  final datePublished;
  final String profileImage;
  final likes;

  Comment({
    required this.comment,
    required this.commentId,
    required this.userName,
    required this.postId,
    required this.datePublished,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'comment': comment,
        'commentId': commentId,
        'userName': userName,
        'postId': postId,
        'datePublished': datePublished,
        'profileImage': profileImage,
        'likes': likes,
      };

  static Comment fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Comment(
      userName: snap['username'],
      commentId: snap['commentId'],
      comment: snap['comment'],
      postId: snap['postId'],
      profileImage: snap['profielImage'],
      likes: snap['likes'],
      datePublished: snap['datePublished'],
    );
  }
}
