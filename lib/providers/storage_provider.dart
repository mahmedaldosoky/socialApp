import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/providers/emit_provider.dart';

// for Edit profile screen
class StorageProvider extends ChangeNotifier {
  FirebaseStorage storage = FirebaseStorage.instance;

  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController postController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? profileImage;
  XFile? coverImage;
  XFile? postImage;

  Future pickProfileImage() async {
    profileImage =
        await _picker.pickImage(source: ImageSource.gallery); // select image

    notifyListeners();
  }

  Future pickCoverImage() async {
    coverImage =
        await _picker.pickImage(source: ImageSource.gallery); // select image

    notifyListeners();
  }

  Future pickPostImage() async {
    postImage =
        await _picker.pickImage(source: ImageSource.gallery); // select image

    notifyListeners();
  }

  Future unpickPostImage() async {
    postImage = null;
    notifyListeners();
  }

  Future<String> postFile(
      {required File imageFile, required String folderPath}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference =
        FirebaseStorage.instance.ref().child(folderPath).child(fileName);

    TaskSnapshot storageTaskSnapshot = await reference.putFile(imageFile);

    String dowUrl = await storageTaskSnapshot.ref.getDownloadURL();

    print(dowUrl);
    return dowUrl;
  }

  Future updateUserData(BuildContext context, UserModel user) async {
    /// update profile Pic
    if (profileImage != null) {
      String profileImageLink = await postFile(
              imageFile: File(profileImage!.path), folderPath: "profile-img")
          .then(
        (value) {
          print('profile image updated successfully.');
          return value;
        },
      ).catchError(
        (onError) {
          print(onError);
        },
      ); // upload to firebase Storage

      await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).changeUserAttribute('image',
          profileImageLink); // update user profile image in fireStore with the new link
    }

    /// update Cover image
    if (coverImage != null) {
      String coverImageLink =
          await postFile(imageFile: File(coverImage!.path), folderPath: "cover")
              .then(
        (value) {
          print('cover updated successfully.');
          return value;
        },
      ).catchError(
        (onError) {
          print(onError);
        },
      ); // upload to firebase Storage

      await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).changeUserAttribute('cover',
          coverImageLink); // update user cover in fireStore with the new link
    }

    /// update the other data : name , bio , phone
    // the received user is user data before update
    if (user.username != usernameController.text &&
        usernameController.text != '') {
      Provider.of<AuthProvider>(context, listen: false)
          .changeUserAttribute('username', usernameController.text);
    }
    if (user.bio != bioController.text && bioController.text != '') {
      Provider.of<AuthProvider>(context, listen: false)
          .changeUserAttribute('bio', bioController.text);
    }
    if (user.phone != phoneController.text && phoneController.text != '') {
      Provider.of<AuthProvider>(context, listen: false)
          .changeUserAttribute('phone', phoneController.text);
    }

    notifyListeners();
  }

  Future createPost(context) async {
    if (postImage == null && postController.text == '') {
      print('No post or image');
      Provider.of<EmitProvider>(context, listen: false)
          .emitPostCreatedFailedState();
      return;
    } else {
      // upload image if available then create post as object
      late PostModel newPost;
      if (postImage != null) {
        await postFile(
          imageFile: File(postImage!.path),
          folderPath: 'post-img',
        ).then(
          (value) {
            // post with image
            newPost = PostModel(
              username: Provider.of<AuthProvider>(context, listen: false)
                  .currentUserData!
                  .username,
              uid: Provider.of<AuthProvider>(context, listen: false)
                  .currentUserData!
                  .uid,
              userImage: Provider.of<AuthProvider>(context, listen: false)
                  .currentUserData!
                  .image,
              dateTime: DateTime.now().toString(),
              text: postController.text == '' ? null : postController.text,
              postImage: value,
              postId: null,
            );
          },
        ).catchError(
          (onError) {
            print('Error uploading the image:' + onError);
          },
        );
      } else {
        // post without image
        newPost = PostModel(
          username: Provider.of<AuthProvider>(context, listen: false)
              .currentUserData!
              .username,
          uid: Provider.of<AuthProvider>(context, listen: false)
              .currentUserData!
              .uid,
          userImage: Provider.of<AuthProvider>(context, listen: false)
              .currentUserData!
              .image,
          dateTime: DateTime.now().toString(),
          text: postController.text == '' ? null : postController.text,
          postId: null,
        );
      }

      // upload post data to FireStore
      await Provider.of<AuthProvider>(context, listen: false)
          .createPostOnFireStore(newPost)
          .then((value) {
        Provider.of<EmitProvider>(context, listen: false)
            .emitPostCreatedSuccessState();
      });
    }
  }

  Future editPost(BuildContext context, PostModel post) async {
    if (postImage == null && postController.text == '') {
      print('No post or image');
      Provider.of<EmitProvider>(context, listen: false)
          .emitPostCreatedFailedState();
      return;
    } else {
      // upload image if available then create post as object
      late PostModel newPost;
      if (postImage != null) {
        await postFile(
          imageFile: File(postImage!.path),
          folderPath: 'post-img',
        ).then(
          (value) {
            // post with image
            newPost = PostModel(
              username: Provider.of<AuthProvider>(context, listen: false)
                  .currentUserData!
                  .username,
              uid: Provider.of<AuthProvider>(context, listen: false)
                  .currentUserData!
                  .uid,
              userImage: Provider.of<AuthProvider>(context, listen: false)
                  .currentUserData!
                  .image,
              dateTime: DateTime.now().toString(),
              text: postController.text == '' ? null : postController.text,
              postImage: value,
              postId: post.postId,
              likesNum: post.likesNum,
              commentsNum: post.commentsNum,
            );
          },
        ).catchError(
          (onError) {
            print('Error uploading the image:' + onError);
          },
        );
      } else {
        print('ddddddxx');
        // post without image
        newPost = PostModel(
          username: Provider.of<AuthProvider>(context, listen: false)
              .currentUserData!
              .username,
          uid: Provider.of<AuthProvider>(context, listen: false)
              .currentUserData!
              .uid,
          userImage: Provider.of<AuthProvider>(context, listen: false)
              .currentUserData!
              .image,
          dateTime: DateTime.now().toString(),
          text: postController.text == '' ? null : postController.text,
          postId: post.postId,
          likesNum: post.likesNum,
          commentsNum: post.commentsNum,
        );
      }


      print(newPost.postId);
      // upload post data to FireStore
      await Provider.of<AuthProvider>(context, listen: false)
          .updatePostOnFireStore(newPost)
          .then((value) {
        Provider.of<EmitProvider>(context, listen: false)
            .emitPostCreatedSuccessState();
        notifyListeners();
      });

    }
  }
}
