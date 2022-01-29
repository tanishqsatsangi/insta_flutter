import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/global_variables.dart';
import 'package:social_media_app/utils/utils.dart';
import 'package:social_media_app/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isWebScreenSize(context)
          ? AppBar(
              backgroundColor: mobileBackgroundColor,
            )
          : getMobileFeedAppBar(context),
      body: getFeedStream(),
    );
  }

  AppBar getMobileFeedAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: mobileBackgroundColor,
      centerTitle: false,
      title: SvgPicture.asset(
        assetName,
        height: 32,
        color: Colors.white,
      ),
      actions: [
        IconButton(
          onPressed: () {
            showSnackBar("Feature is Coming Soon!", context);
          },
          icon: const Icon(
            Icons.send,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget getFeedStream() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return getCircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        });
  }
}
