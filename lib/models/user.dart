import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String userName;
  final String bio;
  final List followers;
  final List followings;

  User.name(this.email, this.uid, this.photoUrl, this.userName, this.bio,
      this.followers, this.followings);

  User(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.userName,
      required this.bio,
      required this.followers,
      required this.followings});

  Map<String, dynamic> toJson() => {
        'username': userName,
        'uid': uid,
        'email': email,
        'bio': bio,
        'followers': followers,
        'following': followings,
        'photoUrl': photoUrl,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
      userName: snap['username'],
      uid: snap['uid'],
      email: snap['email'],
      bio: snap['bio'],
      followings: snap['following'],
      followers: snap['followers'],
      photoUrl: snap['photoUrl'],
    );
  }
}
