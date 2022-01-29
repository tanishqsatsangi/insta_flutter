import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/providers/user_provider.dart';
import 'package:social_media_app/resources/firestore_provider.dart';
import 'package:social_media_app/screens/comment_screen.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/utils.dart';
import 'package:social_media_app/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentsSize = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    print('in post card for snap ${widget.snap['likes']}');
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        children: [
          _postHeader(context),
          _imageBox(context, user.uid),
          _likeCommentSection(context, user),
          _description(context),
        ],
      ),
    );
  }

  Widget _description(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            child: Text(
              '${(widget.snap['likes'].length)}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 8,
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: primaryColor,
                ),
                children: [
                  TextSpan(
                    text: widget.snap['userName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' ${(widget.snap['description'])}',
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "View all $commentsSize comments",
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
              style: TextStyle(
                fontSize: 12,
                color: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _likeCommentSection(BuildContext context, User user) {
    return Row(
      children: [
        LikeAnimation(
          isAnimating: widget.snap['likes'].contains(user.uid),
          smallLike: true,
          child: IconButton(
            onPressed: () async {
              await FireStoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
                false,
              );
            },
            icon: Icon(
              widget.snap['likes'].contains(user.uid)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CommentScreen(
                snap: widget.snap,
              ),
            ),
          ),
          icon: const Icon(
            Icons.comment_outlined,
            color: Colors.white70,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.send,
            color: Colors.white,
          ),
        ),
        Expanded(
            child: Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_border,
              color: Colors.white,
            ),
          ),
        ))
      ],
    );
  }

  Widget _imageBox(BuildContext context, String uid) {
    return GestureDetector(
      onDoubleTap: () async {
        await FireStoreMethods()
            .likePost(widget.snap['postId'], uid, widget.snap['likes'], true);
        setState(() {
          isLikeAnimating = true;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            width: double.infinity,
            child: Image.network(
              widget.snap['postUrl'],
              fit: BoxFit.cover,
            ),
          ),
          AnimatedOpacity(
            duration: Duration(
              milliseconds: 200,
            ),
            opacity: isLikeAnimating ? 1 : 0,
            child: LikeAnimation(
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 100,
              ),
              isAnimating: isLikeAnimating,
              duration: Duration(milliseconds: 400),
              onEnd: () {
                setState(() {
                  isLikeAnimating = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _postHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ).copyWith(
        right: 0,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              widget.snap['profileImage'],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.snap['userName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                    shrinkWrap: true,
                    children: ['Delete']
                        .map(
                          (e) => InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              child: Text(e),
                            ),
                            onTap: () async {
                              String response =
                                  await FireStoreMethods().deletePost(
                                widget.snap['postId'],
                              );
                              Navigator.of(context).pop();
                              showSnackBar(response, context);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
            icon: Icon(Icons.more_vert_sharp),
          ),
        ],
      ),
    );
  }

  void getComments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentsSize = querySnapshot.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
}
