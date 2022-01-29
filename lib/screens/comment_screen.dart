import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/providers/user_provider.dart';
import 'package:social_media_app/resources/firestore_provider.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/utils.dart';
import 'package:social_media_app/widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentInputController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: const Text('Comments'),
      ),
      bottomNavigationBar: commentBottomWidget(user),
      body: commentStream(),
    );
  }

  SafeArea commentBottomWidget(User user) {
    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(
          left: 16,
          right: 8,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                user.photoUrl,
              ),
            ),
            commentInputFieldWidget(user),
            postCommentButton(user),
          ],
        ),
      ),
    );
  }

  Expanded commentInputFieldWidget(User user) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: TextField(
          controller: commentInputController,
          decoration: InputDecoration(
            hintText: 'Comment as  ${user.userName}',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  InkWell postCommentButton(User user) {
    return InkWell(
      onTap: () async {
        if (commentInputController.text.isNotEmpty) {
          await FireStoreMethods().postComment(widget.snap['postId'], user.uid,
              commentInputController.text, user.userName, user.photoUrl);
        }
        setState(() {
          commentInputController.text = "";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        child: const Text(
          'Post',
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  Widget commentStream() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return getCircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: (snapshot.data! as dynamic).docs[index].data(),
            ),
          );
        });
  }
}
