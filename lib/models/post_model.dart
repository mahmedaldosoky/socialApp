class PostModel {
  String username;
  String uid;
  String userImage;
  String dateTime;
  String? postImage;
  String? text;
  String? postId;
  String? likesNum;
  String? commentsNum;

  // Not in fireStore
 // bool isPostLikedByMe=false;
  //List<String> likes = [];


  PostModel({
    required this.username,
    required this.uid,
    required this.userImage,
    required this.dateTime,
    required this.postId,
    this.postImage,
    this.text,
    this.commentsNum='0',
    this.likesNum='0',
  });

  static PostModel fromJson(Map<String, dynamic> json) {
    return PostModel(
      username: json['username'],
      uid: json['uid'],
      userImage: json['userImage'],
      dateTime: json['dateTime'],
      postImage: json['postImage'],
      text: json['text'],
      postId: json['postId'],
      likesNum: json['likesNum'],
      commentsNum: json['commentsNum'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'userImage': userImage,
      'dateTime': dateTime,
      'postImage': postImage,
      'text': text,
      'postId': postId,
      'likesNum': likesNum,
      'commentsNum': commentsNum,
    };
  }
}
