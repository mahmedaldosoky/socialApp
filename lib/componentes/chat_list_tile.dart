import 'package:flutter/material.dart';
import 'package:social/models/user_model.dart';
import 'package:social/screens/new_chat_details_screen.dart';

class ChatListTile extends StatelessWidget {
  final UserModel userData;
  final Widget? trailing;
  final Widget? subtitle;
  ChatListTile({required this.userData,this.trailing,this.subtitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
         //   builder: (builder) => ChatDetailsScreen(friendData: userData),
            builder: (builder) => NewChatDetailsScreen(friendData: userData),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ListTile(
          trailing:trailing,
          subtitle: subtitle,
          leading: Container(
            width: 55,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image.network(
                userData.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            userData.username,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  letterSpacing: 1.5,
                ),
          ),
          //  subtitle: Text('Hello World'),
        ),
      ),
    );
  }
}
