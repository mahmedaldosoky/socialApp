import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/message_model.dart';
import 'package:social/providers/auth_provider.dart';

class Message extends StatelessWidget {
  final MessageModel messageData;

  const Message({required this.messageData});

  @override
  Widget build(BuildContext context) {
    final bool isMyMessage =
        Provider.of<AuthProvider>(context).currentUserData!.uid ==
                messageData.senderUid
            ? true
            : false;

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isMyMessage ? Colors.lightBlue[200] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight:
                !isMyMessage ? Radius.circular(10) : Radius.circular(0),
            bottomLeft: !isMyMessage ? Radius.circular(0) : Radius.circular(10),
          ),
        ),
        child: Text(
          messageData.messageText,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 16,
              ),
        ),
      ),
    );
  }
}
