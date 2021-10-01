import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/post_model.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/providers/emit_provider.dart';
import 'package:social/providers/loading_provider.dart';
import 'package:social/providers/storage_provider.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel post;

  EditPostScreen({required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController editPostController;

  @override
  void initState() {
    super.initState();
    editPostController = TextEditingController(text: widget.post.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Edit Post"),
        actions: [
          TextButton(
            onPressed: () async {
              PostModel postAfterEdit = widget.post;
              postAfterEdit.text = editPostController.text;
              await Provider.of<AuthProvider>(context, listen: false)
                  .updatePostOnFireStore(postAfterEdit);
              Navigator.pop(context);
            },
            child: Text(
              "Update",
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
                  controller: editPostController,
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
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: widget.post.postImage != null
                      ? Align(
                          alignment: Alignment.center,
                          child: Image.network(widget.post.postImage!),
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
