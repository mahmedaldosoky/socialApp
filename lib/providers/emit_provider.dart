import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class EmitProvider extends ChangeNotifier {

  emitPostCreatedSuccessState(){
    showToast('Post Created Successfully');
  }  emitPostCreatedFailedState(){
    showToast('Post Failure',backgroundColor: Colors.red);
  }
  emitPostLikeSuccessState(){
   // showToast('Post Created Successfully');

  }  emitAddCommentSuccessState(){
    showToast('Comment Added');

  }

}