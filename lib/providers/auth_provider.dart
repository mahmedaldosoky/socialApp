import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social/models/comment_model.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/providers/emit_provider.dart';
import 'package:social/screens/layout_screen.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserModel? currentUserData;

  List<PostModel> posts = [];
  List<MessageModel> messages = [];

  List<ChatMessage> chatMessages = [];

  bool loginLoading = false; // CircularProgressIndicator instead button
  bool registerLoading = false; // CircularProgressIndicator instead button
  bool finishedLoadingUserData = false;

  loginEmail(String email, String password, context) async {
    loginLoading = true;
    notifyListeners();

    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      //check
      print(value.user!.email);
      print(value.user!.uid);

      //circular
      loginLoading = false;
      notifyListeners();

      //to layout
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => LayoutScreen(),
        ),
        (route) => false,
      );
    }).catchError((error) {
      String shownError =
          error.toString().substring(error.toString().lastIndexOf(']') + 2);
      showToast(
        shownError,
        backgroundColor: Colors.red,
      );
      loginLoading = false;
      notifyListeners();
    });
  }

  Future registerEmail(context, String email, String password, String username,
      String phone) async {
    registerLoading = true;
    notifyListeners();

    //register
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      //create user model
      UserModel user = UserModel(
        email: email,
        uid: value.user!.uid,
        username: username,
        phone: phone,
      );

      // add user to firestore
      firestore.collection('users').doc(value.user!.uid).set(user.toMap());

      print(value.user!.email);
      print(value.user!.uid);

      registerLoading = false;
      notifyListeners();

      // Navigate to Layout after Register
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => LayoutScreen()),
          (route) => false);
    }).catchError((error) {
      String shownError =
          error.toString().substring(error.toString().lastIndexOf(']') + 2);
      showToast(
        shownError,
        backgroundColor: Colors.red,
      );
      registerLoading = false;
      notifyListeners();
    });
  }

  Future getCurrentUserData() async {
    return await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then(
      (value) {
        Map<String, dynamic>? userMap = value.data();

        // Json to Object
        UserModel user = UserModel.fromJson(userMap!);
        currentUserData = user;
        finishedLoadingUserData =
            true; // to end CircularProgressIndicator in layoutScreen
        notifyListeners();
        //return user;
      },
    ).catchError(
      (error) {
        print(error);
      },
    );
  }

  Future<UserModel> getUserDataWithUid(String uid) async {
    return await firestore.collection('users').doc(uid).get().then((value) {
      Map<String, dynamic>? userMap = value.data();

      // Json to Object
      UserModel user = UserModel.fromJson(userMap!);
      return user;
    });
  }

  changeUserAttribute(String attribute, String newValue) async {
    // change user attribute from fireStore
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      attribute: newValue,
    });
  }

  Future createPostOnFireStore(PostModel post) async {
    await firestore.collection('posts').add(post.toMap()).then((value) async {
      await firestore.collection('posts').doc(value.id).update({
        'postId': value.id,
      }); // Add postId to post doc in fireStore
      print('uploaded post successfully');
    }).catchError((onError) {
      print(onError);
    });
  }

  Future updatePostOnFireStore(PostModel post) async {
    await firestore
        .collection('posts')
        .doc(post.postId)
        .update(post.toMap())
        .catchError((onError) {
      print(onError);
    });
  }

  Future<List<PostModel>> getPosts() async {
    posts = []; // delete posts before downloading posts
    await firestore.collection('posts').orderBy('dateTime',descending: true).get().then((value) {
      value.docs.forEach((element) {
        PostModel postData = PostModel.fromJson(element.data());

        posts.add(postData);
      });
    });

    return posts;
  }

  Future<void> likePost(PostModel post) async {
    var postDocRef = firestore.collection('posts').doc(post.postId);

    await postDocRef.collection('likes').doc(currentUserData!.uid).set({
      'dateTime': DateTime.now().toString(),
    }).then((value) async {
      // increase post likes num
      postDocRef.get().then((value) async {
        PostModel postData =
            PostModel.fromJson(value.data()!); // post with current Data

        await postDocRef.update(
            {'likesNum': (int.parse(postData.likesNum ?? "0") + 1).toString()});
      });
    });
  }

  Future<void> disLikePost(PostModel post) async {
    var postDocRef = firestore.collection('posts').doc(post.postId);

    await postDocRef
        .collection('likes')
        .doc(currentUserData!.uid)
        .delete()
        .then((value) {
      // decrease post likes num
      postDocRef.get().then((value) async {
        PostModel postData =
            PostModel.fromJson(value.data()!); // post with current Data

        await postDocRef.update({
          'likesNum': postData.likesNum != null && postData.likesNum != '0'
              ? (int.parse(postData.likesNum!) - 1).toString()
              : '0'
        });
      });
    });
  }

  Future<String> getPostLikesNum(PostModel post) async {
    var postDocRef = firestore.collection('posts').doc(post.postId);

    await Future.delayed(Duration(milliseconds: 700));
    return await postDocRef.get().then((value) {
      PostModel postData = PostModel.fromJson(value.data()!);
      return postData.likesNum ?? '0'; // if No likes return 0 instead of null
    });
  }

  Future<bool> isPostLikedByMe(PostModel post) async {
    var postDocRef = firestore.collection('posts').doc(post.postId);

    return await postDocRef.collection('likes').get().then((value) {
      return value.docs.any((element) => element.id == (currentUserData!.uid));
    });
  }

  Future postLikeButtonClicked(PostModel post) async {
    await isPostLikedByMe(post) ? disLikePost(post) : likePost(post);
  }

  Future deletePost(PostModel post) async {
    await firestore.collection('posts').doc(post.postId).delete().then((value) {
      EmitProvider().emitDeletePostSuccessState();
    }).catchError((onError) {
      EmitProvider().emitDeletePostFailedState();
    });
    notifyListeners();
  }

  Future<List<UserModel>> getChats() async {
    // get friends I chat with.

    List<UserModel> chats = [];

    return await firestore
        .collection('users')
        .doc(currentUserData!.uid.trim())
        .collection('chats')
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        await getUserDataWithUid(element.id.trim()).then((value) {
          chats.add(value);
        });
      });
      await Future.delayed(Duration(milliseconds: 500));
      return chats;
    });
  }

/*  Future sendMessage(String messageText, UserModel friendData) async {
    MessageModel message = MessageModel(
      messageText: messageText.trim(),
      senderUid: currentUserData!.uid.trim(),
      receiverUid: friendData.uid.trim(),
      dateTime: DateTime.now().toString(),
    );

    // To make doc not empty
    await firestore
        .collection('users')
        .doc(message.senderUid.trim())
        .collection('chats')
        .doc(message.receiverUid.trim())
        .set({'chatBackground': null});
    //send message to my chats collection
    await firestore
        .collection('users')
        .doc(message.senderUid.trim())
        .collection('chats')
        .doc(message.receiverUid.trim())
        .collection('messages')
        .doc()
        .set(message.toMap());

    // To make doc not empty
    await firestore
        .collection('users')
        .doc(message.receiverUid.trim())
        .collection('chats')
        .doc(message.senderUid.trim())
        .set({'chatBackground': null});

    //send message to my friend's chats collection
    await firestore
        .collection('users')
        .doc(message.receiverUid.trim())
        .collection('chats')
        .doc(message.senderUid.trim())
        .collection('messages')
        .doc()
        .set(message.toMap());
  }*/

  ///For new chating screen

  Future sendMessage(ChatMessage chatMessage, UserModel friendData) async {
    MessageModel message = MessageModel(
      messageText: chatMessage.text!,
      senderUid: currentUserData!.uid.trim(),
      receiverUid: friendData.uid.trim(),
      dateTime: DateTime.now().toString(),
    );

    // To make doc not empty
    await firestore
        .collection('users')
        .doc(message.senderUid.trim())
        .collection('chats')
        .doc(message.receiverUid.trim())
        .set({'chatBackground': null});
    //send message to my chats collection
    await firestore
        .collection('users')
        .doc(message.senderUid.trim())
        .collection('chats')
        .doc(message.receiverUid.trim())
        .collection('messages')
        .doc()
        .set(message.toMap());

    // To make doc not empty
    await firestore
        .collection('users')
        .doc(message.receiverUid.trim())
        .collection('chats')
        .doc(message.senderUid.trim())
        .set({'chatBackground': null});

    //send message to my friend's chats collection
    await firestore
        .collection('users')
        .doc(message.receiverUid.trim())
        .collection('chats')
        .doc(message.senderUid.trim())
        .collection('messages')
        .doc()
        .set(message.toMap());
  }

/*  Stream<List<MessageModel>> getMessagesWithUser(UserModel friend) async* {
    messages = [];
    firestore
        .collection('users')
        .doc(currentUserData!.uid)
        .collection('chats')
        .doc(friend.uid)
        .collection('messages')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        MessageModel message = MessageModel.fromJson(element.data());

        messages.add(message);
      });
    });
    yield messages;
  }*/

  ///For new chating screen
  Stream<List<ChatMessage>> getMessagesWithUser(UserModel friend) async* {
    ChatUser friendChatUser = ChatUser(
      uid: friend.uid,
      avatar: friend.image,
      name: friend.username,
    );
    ChatUser myChatUser = ChatUser(
      uid: currentUserData!.uid,
      avatar: currentUserData!.image,
      name: currentUserData!.username,
    );

    chatMessages = [];

    firestore
        .collection('users')
        .doc(currentUserData!.uid)
        .collection('chats')
        .doc(friend.uid)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        MessageModel message = MessageModel.fromJson(element.data());
        ChatMessage chatMessage = ChatMessage(
          text: message.messageText,
          user:
              message.senderUid == myChatUser.uid ? myChatUser : friendChatUser,
          createdAt: DateTime.parse(message.dateTime),
        );

        chatMessages.add(chatMessage);
      });
    });
    yield chatMessages;
  }

  Stream<List<MessageModel>> getMessagesWithUserUid(String friendUid) async* {
    messages = [];
    firestore
        .collection('users')
        .doc(currentUserData!.uid)
        .collection('chats')
        .doc(friendUid)
        .collection('messages')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        MessageModel message = MessageModel.fromJson(element.data());

        messages.add(message);
      });
    });
    yield messages;
  }

  Future<List<UserModel>> getUsers() async {
    List<UserModel> users = [];
    return await firestore.collection('users').get().then((value) {
      value.docs.forEach((element) {
        UserModel user = UserModel.fromJson(element.data());
        if (user.uid != currentUserData!.uid) {
          users.add(user);
        }
      });
      return users;
    });
  }

  /// Comments
  Future<void> addComment(PostModel postData, String commentText) async {
    CommentModel commentData = CommentModel(
      commentText: commentText,
      commentId: '',
      postId: postData.postId!,
      dateTime: DateTime.now().toString(),
      uid: currentUserData!.uid,
    );
    var postDocRef = firestore.collection('posts').doc(postData.postId);

    await postDocRef
        .collection('comments')
        .add(commentData.toMap())
        .then((value) async {
      // add commentId in firestore
      await postDocRef
          .collection('comments')
          .doc(value.id)
          .update({'commentId': value.id});

      // add 1 to commentsNum
      String commentsNumPlusOne =
          (int.parse(postData.commentsNum!) + 1).toString();
      await postDocRef.update({'commentsNum': commentsNumPlusOne});

      EmitProvider().emitAddCommentSuccessState();
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<String> getPostCommentsNum(PostModel postData) async {
    return await firestore
        .collection('posts')
        .doc(postData.postId)
        .collection('comments')
        .get()
        .then((value) {
      return value.docs.length.toString();
    });
  }

/*  Future<String> getCommentsNum(PostModel post) async {
    var postDocRef = firestore.collection('posts').doc(post.postId);

    //  await Future.delayed(Duration(milliseconds: 700));
    return await postDocRef.get().then((value) {
      PostModel postData = PostModel.fromJson(value.data()!);
      return postData.commentsNum ?? '0';
    });
  }*/

  Future<List<CommentModel>> getComments(PostModel post) async {
    var postDocRef = firestore.collection('posts').doc(post.postId);

    List<CommentModel> comments = [];
    return await postDocRef.collection('comments').get().then((value) {
      value.docs.forEach((element) {
        CommentModel comment = CommentModel.fromJson(element.data());
        comments.add(comment);
      });
    }).then((value) {
      return comments;
    });
  }

  Future likeComment(CommentModel commentData) async {
    var commentDocRef = firestore
        .collection('posts')
        .doc(commentData.postId)
        .collection('comments')
        .doc(commentData.commentId);

    await commentDocRef.collection('likes').doc(currentUserData!.uid).set({
      'dateTime': DateTime.now().toString(),
    }).then((value) async {
      //get current comments likes number
      int currentCommentsLikesNum = await commentDocRef.get().then((value) {
        return int.parse(value.data()!['likesNum']);
      });

      //update comments likes number
      await commentDocRef.update({
        'likesNum': (currentCommentsLikesNum + 1).toString(),
      });
    });
  }

  Future unLikeComment(CommentModel commentData) async {
    var commentDocRef = firestore
        .collection('posts')
        .doc(commentData.postId)
        .collection('comments')
        .doc(commentData.commentId);

    await commentDocRef
        .collection('likes')
        .doc(currentUserData!.uid)
        .delete()
        .then((value) async {
      //get current comments likes number
      int currentCommentsLikesNum = await commentDocRef.get().then((value) {
        return int.parse(value.data()!['likesNum']);
      });

      //update comments likes number
      await commentDocRef.update({
        'likesNum': (currentCommentsLikesNum - 1).toString(),
      });
    });
  }

  Future<bool> isCommentLikedByMe(CommentModel commentData) async {
    var commentDocRef = firestore
        .collection('posts')
        .doc(commentData.postId)
        .collection('comments')
        .doc(commentData.commentId);

    return await commentDocRef.collection('likes').get().then((value) {
      return value.docs.any((element) {
        return element.id == currentUserData!.uid;
      });
    });
  }
}
