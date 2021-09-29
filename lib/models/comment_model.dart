class CommentModel {
  String commentText;
  String commentId;
  String postId;
  String dateTime;
  String uid;
  String likesNum;

  CommentModel({
    required this.commentText,
    required this.commentId,
    required this.postId,
    required this.dateTime,
    required this.uid,
    this.likesNum = "0",
  });

  static CommentModel fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentText: json['commentText'],
      dateTime: json['dateTime'],
      commentId: json['commentId'],
      postId: json['postId'],
      likesNum: json['likesNum'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentText': commentText,
      'dateTime': dateTime,
      'commentId': commentId,
      'postId': postId,
      'likesNum': likesNum,
      'uid': uid,
    };
  }
}
