import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/providers/emit_provider.dart';
import 'package:social/providers/loading_provider.dart';
import 'package:social/providers/storage_provider.dart';

// ignore: must_be_immutable
class CreatePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Add Post"),
        actions: [
          TextButton(
            onPressed: () async {
              Provider.of<LoadingProvider>(context,listen: false).startPostLoading();

              await Provider.of<StorageProvider>(context, listen: false)
                  .createPost(context)
                  .catchError(
                (onError) {
                  print(onError);
                  Provider.of<EmitProvider>(context, listen: false)
                      .emitPostCreatedFailedState();
                },
              );
              Provider.of<LoadingProvider>(context,listen: false).finishPostLoading();
              Navigator.pop(context);
            },
            child: Text(
              "Post",
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
                      onPressed: () async {
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
                      onPressed: () {},
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
