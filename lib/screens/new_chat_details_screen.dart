import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/user_model.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:social/providers/auth_provider.dart';

// ignore: must_be_immutable
class NewChatDetailsScreen extends StatefulWidget {
  final UserModel friendData;

  NewChatDetailsScreen({required this.friendData});

  @override
  State<NewChatDetailsScreen> createState() => _NewChatDetailsScreenState();
}

class _NewChatDetailsScreenState extends State<NewChatDetailsScreen> {
  ScrollController scrollController = ScrollController();

  /* sortMessages(List<ChatMessage>? messages) {
    messages!.sort((a, b) {
      return a.createdAt.compareTo(b.createdAt);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.network(
                //'https://media-exp1.licdn.com/dms/image/C5603AQE6z7P-aE4-uQ/profile-displayphoto-shrink_800_800/0/1631742017830?e=1637798400&v=beta&t=9PB491Sdww_7pCokmz0jmXvDz5B4QaUsbdzLxLr9iFo',

                widget.friendData.image,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(widget.friendData.username),
          ],
        ),
      ),
      body: StreamBuilder<List<ChatMessage>>(
        stream: Provider.of<AuthProvider>(context)
            .getMessagesWithUser(widget.friendData),
        builder:
            (BuildContext context, AsyncSnapshot<List<ChatMessage>> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            // sort messages list
            //   sortMessages(snapshot.data);

            return DashChat(
              scrollController: scrollController,
              sendButtonBuilder: (sendButtonBuilder) {
                return Container(
                  color: Theme.of(context).primaryColor,
                  width: 70,
                  child: IconButton(
                    onPressed: () async {
                      await sendButtonBuilder();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                );
              },
              user: ChatUser(
                name: Provider.of<AuthProvider>(context)
                    .currentUserData!
                    .username,
                uid: Provider.of<AuthProvider>(context).currentUserData!.uid,
                avatar:
                    Provider.of<AuthProvider>(context).currentUserData!.image,
              ),
              onSend: (chatMessage) async {
                print(chatMessage.user.uid);


                await Provider.of<AuthProvider>(context, listen: false)
                    .sendMessage(chatMessage, widget.friendData);
                setState(() {});
                Provider.of<AuthProvider>(context, listen: false).chatMessages =
                    [];
                //   sortMessages(snapshot.data); // sort messages
              },
              messages: snapshot.data ?? [],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
