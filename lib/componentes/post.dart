import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social/models/post_model.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/screens/comment_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Post extends StatefulWidget {
  final PostModel post;

  Post({required this.post});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: double.infinity,
        //height: MediaQuery.of(context).size.height * .4,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.post.userImage,
                    ),
                    radius: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.post.username,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          /*              Icon(
                            Icons.check_circle,
                            color: Colors.lightBlue,
                            size: 17,
                          ),*/
                        ],
                      ),
                      Text(
                        //"August 21, 2021 at 11:00 pm",
                        widget.post.dateTime,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * .2,
                          child: ListView(
                            children: [
                              ListTile(
                                title: Text('Edit Post'),
                                leading: Icon(Icons.edit),

                                onTap: () {}, // todo:
                              ),
                              ListTile(
                                title: Text(
                                  'Delete Post',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onTap: () async {
                                  await Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .deletePost(widget.post);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: FaIcon(FontAwesomeIcons.ellipsisH),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.grey,
                height: .5,
                width: double.infinity,
              ),
              SizedBox(
                height: 10,
              ),
              widget.post.text != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, top: 5),
                      child: Text(
                        widget.post.text.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    )
                  : Container(
                      width: 0,
                    ),
              /* Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '#Software',
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '#Flutter',
                    ),
                  ),
                ],
              ),*/
              widget.post.postImage != null
                  ? Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(widget.post.postImage.toString()),
                        ),
                      ),
                    )
                  : Container(
                      width: 0,
                    ),
              Row(
                children: [
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * .4,
                    onPressed: () async {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .postLikeButtonClicked(widget.post);
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        FutureBuilder<bool>(
                          future: Provider.of<AuthProvider>(context)
                              .isPostLikedByMe(widget.post),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.hasData) {
                              return FaIcon(
                                !snapshot.data!
                                    ? FontAwesomeIcons.heart
                                    : FontAwesomeIcons.solidHeart,
                                color: Colors.redAccent,
                                size: 15,
                              );
                            } else {
                              return Container(
                                  width: 10, child: LinearProgressIndicator());
                            }
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FutureBuilder(
                          future: Provider.of<AuthProvider>(context)
                              .getPostLikesNum(widget.post),
                          builder: (builder, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: Colors.grey[700],
                                    ),
                              );
                            } else {
                              return Container(
                                  width: 10, child: LinearProgressIndicator());
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  MaterialButton(
                    padding: EdgeInsets.all(0),
                    minWidth: MediaQuery.of(context).size.width * .4,
                    onPressed: () {
                      showCommentsModalBottomSheet(context);
                    },
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.comment,
                          color: Colors.yellowAccent,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FutureBuilder(
                          future: Provider.of<AuthProvider>(context)
                              .getCommentsNum(widget.post),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: Colors.grey[700],
                                    ),
                              );
                            } else {
                              return Container(
                                width: 10,
                                child: LinearProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.grey,
                height: .5,
                width: double.infinity,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      showCommentsModalBottomSheet(context);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            Provider.of<AuthProvider>(context)
                                .currentUserData!
                                .image,
                          ),
                          radius: 20,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'write a comment...',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey[700],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  FutureBuilder<bool>(
                    future: Provider.of<AuthProvider>(context)
                        .isPostLikedByMe(widget.post),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData) {
                        return MaterialButton(
                            padding: EdgeInsets.all(0),
                            minWidth: MediaQuery.of(context).size.width * .2,
                            onPressed: () async {
                              await Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .postLikeButtonClicked(widget.post);
                              setState(() {}); // to update likes num
                            },
                            child: Row(
                              children: [
                                FaIcon(
                                  snapshot.data!
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                  color: Colors.redAccent,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  snapshot.data! ? 'Liked' : 'Like',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: Colors.grey[700],
                                      ),
                                ),
                              ],
                            ));
                      } else {
                        return Container(
                            width: 10, child: LinearProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCommentsModalBottomSheet(BuildContext context) {
    return showBarModalBottomSheet(
        //  isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.965,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
            ),
            child: CommentScreen(
              postData: widget.post,
            ),
          );
        });
  }
}
