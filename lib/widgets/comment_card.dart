import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/providers/user_provider.dart';
import 'package:social_media_app/resources/firestore_provider.dart';

class CommentCard extends StatefulWidget {
  final snap;

  const CommentCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              widget.snap['profileImage'],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['userName'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '  ${widget.snap['comment']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => FireStoreMethods().likeComment(
              widget.snap['postId'],
              widget.snap['commentId'],
              user.uid,
              widget.snap['likes'],
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: isAlreadyLiked(user.uid) ?Icon(
               Icons.favorite,
                color: Colors.red,
                size: 16,
              ):Icon(
                Icons.favorite_border,
                size: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
  bool isAlreadyLiked(String uid){
   return widget.snap['likes'].contains(uid);
  }
}
