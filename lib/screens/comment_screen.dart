import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/componentes/comment_list_tile.dart';
import 'package:social/models/comment_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/providers/auth_provider.dart';

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();

  final PostModel postData;

  CommentScreen({required this.postData});
}

class _CommentScreenState extends State<CommentScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          title: Text("Comments"),
          centerTitle: true,
        ),
        body: FutureBuilder<List<CommentModel>>(
          // future to get comments
          future:
              Provider.of<AuthProvider>(context).getComments(widget.postData),
          builder: (BuildContext context,
              AsyncSnapshot<List<CommentModel>> commentSnapshot) {
            if (commentSnapshot.hasData) {
              return CommentBox(
                userImage:
                    Provider.of<AuthProvider>(context).currentUserData!.image,
                child: ListView.builder(
                  itemCount: commentSnapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<UserModel>(
                      // user data future
                      future: Provider.of<AuthProvider>(context)
                          .getUserDataWithUid(commentSnapshot.data![index].uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<UserModel> userDataSnapshot) {
                        if (userDataSnapshot.hasData) {
                          return FutureBuilder<bool>(
                            // is liked by me future
                            future: Provider.of<AuthProvider>(context)
                                .isCommentLikedByMe(
                                    commentSnapshot.data![index]),
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> isLikedSnapshot) {
                              if (isLikedSnapshot.hasData) {
                                return CommentListTile(
                                  userData: userDataSnapshot.data!,
                                  commentData: commentSnapshot.data![index],
                                  isLiked: isLikedSnapshot.data!,
                                );
                              } else {
                                return Container(
                                    width: 10,
                                    child: LinearProgressIndicator());
                              }
                            },
                          );
                        } else {
                          return Container(
                              width: 10, child: LinearProgressIndicator());
                        }
                      },
                    );
                  },
                ),
                labelText: 'Write a comment...',
                withBorder: false,
                errorText: 'Comment cannot be blank',
                sendButtonMethod: () async {
                  if (formKey.currentState!.validate()) {
                    print(commentController.text);
                    await Provider.of<AuthProvider>(context, listen: false)
                        .addComment(widget.postData, commentController.text);
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  } else {
                    print("Not validated");
                  }
                },
                formKey: formKey,
                commentController: commentController,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                sendWidget: Icon(
                  Icons.send_sharp,
                  size: 30,
                  color: Colors.white,
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
