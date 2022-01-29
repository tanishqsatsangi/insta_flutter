import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/add_post_screen.dart';
import 'package:social_media_app/screens/feed_screen.dart';
import 'package:social_media_app/screens/profile_screen.dart';
import 'package:social_media_app/screens/search_screen.dart';

const webScreenSize = 600;
var homeScreenWidegets = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("4"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
const String networkDummyImg = 'https://via.placeholder.com/150';

final String assetName = "assests/insstalogo.svg";
