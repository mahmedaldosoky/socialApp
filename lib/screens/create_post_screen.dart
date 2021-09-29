import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social/models/post_model.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/providers/emit_provider.dart';
import 'package:social/providers/loading_provider.dart';
import 'package:social/providers/storage_provider.dart';

class CreateEditPostScreen extends StatelessWidget {
  // post!=null means Editing post not new one
  PostModel? post;

  CreateEditPostScreen({
    this.post,
  });

  @override
  Widget build(BuildContext context) {
    if (post != null) {
      // post!=null means Editing post not new one
      Provider.of<StorageProvider>(context, listen: false).postController.text =
          post!.text!; // Post Text

      if (post!.postImage != null)
        Provider.of<StorageProvider>(context).postImage =
            XFile(post!.postImage!);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(post != null ? 'Edit Post' : "Add Post"),
        actions: [
          TextButton(
            onPressed: () async {
/*              if (post != null) {
                // if Editing Post , Delete the old one first then make new post
                await Provider.of<AuthProvider>(context, listen: false)
                    .deletePost(post!);
              }*/
              Provider.of<LoadingProvider>(context, listen: false)
                  .startPostLoading();

              await Provider.of<StorageProvider>(context, listen: false)
                  .createPost(context)
                  .catchError(
                (onError) {
                  Provider.of<EmitProvider>(context, listen: false)
                      .emitPostCreatedFailedState();
                },
              );
              Provider.of<LoadingProvider>(context, listen: false)
                  .finishPostLoading();

              // Clear before pop
              Provider.of<StorageProvider>(context, listen: false)
                  .postController
                  .clear();
              Provider.of<StorageProvider>(context, listen: false).postImage =
                  null;
              Navigator.pop(context);
            },
            child: Text(
              post != null ? "Edit" : "Post",
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Provider.of<LoadingProvider>(context).postLoading
                  ? LinearProgressIndicator()
                  : Container(
                      width: 0,
                    ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      Provider.of<AuthProvider>(context).currentUserData!.image,
                    ),
                    radius: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    Provider.of<AuthProvider>(context)
                        .currentUserData!
                        .username,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * .4,
                child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  controller:
                      Provider.of<StorageProvider>(context, listen: false)
                          .postController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "What is in your mind?",
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed:
                          Provider.of<StorageProvider>(context).postImage !=
                                  null
                              ? null
                              : () async {
                                  await Provider.of<StorageProvider>(context,
                                          listen: false)
                                      .pickPostImage();
                                },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Add photo'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed:
                          Provider.of<StorageProvider>(context).postImage !=
                                  null
                              ? null
                              : () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.tag),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Tags'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Provider.of<StorageProvider>(context).postImage != null
                      ? Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.file(
                                File(
                                  Provider.of<StorageProvider>(context)
                                      .postImage!
                                      .path,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: IconButton(
                                  onPressed: () {
                                    Provider.of<StorageProvider>(context,
                                            listen: false)
                                        .unpickPostImage();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          width: 0,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
