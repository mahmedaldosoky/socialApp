import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:social/models/comment_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/providers/auth_provider.dart';

class CommentListTile extends StatelessWidget {
  final UserModel userData;
  final Widget? trailing;
  final CommentModel commentData;
 final bool isLiked;

  CommentListTile(
      {required this.userData,
      this.trailing,
      required this.commentData,
      required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ListTile(
          trailing: Container(
            width: 50,
            child: LikeButton(
              likeCount: int.parse(commentData.likesNum),
              onTap: (bool isLiked) async {
                /// send your request here
                isLiked
                    ? await Provider.of<AuthProvider>(context, listen: false)
                        .unLikeComment(commentData)
                    : await Provider.of<AuthProvider>(context, listen: false)
                        .likeComment(commentData);

                /// if failed, you can do nothing
                // return success? !isLiked:isLiked;

                return !isLiked;
              },
              isLiked: isLiked,
            ),
          ),
          subtitle: Text(
            commentData.commentText,
          ),
          leading: Container(
            width: 55,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image.network(
                userData.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            userData.username,
          ),
        ),
      ),
    );
  }
}
