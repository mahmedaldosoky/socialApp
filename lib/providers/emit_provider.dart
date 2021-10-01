import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class EmitProvider extends ChangeNotifier {
  emitPostCreatedSuccessState() {
    showToast('Post Created Successfully');
  }

  emitPostCreatedFailedState() {
    showToast('Post Failure', backgroundColor: Colors.red);
  }  emitPostUpdateSuccessState() {
    showToast('Post Updated Successfully');
  }

  emitPostUpdateFailedState() {
    showToast('Post Update Failure', backgroundColor: Colors.red);
  }

  emitAddCommentSuccessState() {
    showToast('Comment Added');
  }

  emitDeletePostSuccessState() {
    showToast('Post Deleted');
  }

  emitDeletePostFailedState() {
    showToast(
      'Failed to delete post',
      backgroundColor: Colors.red,
    );
  }
}
