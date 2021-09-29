import 'package:flutter/material.dart';
import 'package:social/models/user_model.dart';

/// I am not using this screen (working from scratch), instead using chat package
// ignore: must_be_immutable
class ChatDetailsScreen extends StatefulWidget {
  final UserModel friendData;

  ChatDetailsScreen({required this.friendData});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * .07,
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
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
          /*  Container(
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<List<MessageModel>>(
                stream: Provider.of<AuthProvider>(context)
                    .getMessagesWithUser(widget.friendData),
                builder: (BuildContext context,
                    AsyncSnapshot<List<MessageModel>> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    // sort messages list
                    snapshot.data!.sort((a, b) {
                      return a.dateTime.compareTo(b.dateTime);
                    });

                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      height: MediaQuery.of(context).size.height * .84,
                      child: ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Message(
                            messageData: snapshot.data![index],
                          );
                        },
                        itemCount: snapshot.data!.length,
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),*/
    /*        Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: MediaQuery.of(context).size.height * .075,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: MediaQuery.of(context).size.width * .85,
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(5),
                          topLeft: Radius.circular(5),
                        ),
                        child: DefaultTextField(
                          controller: messageController,
                          hintText: "Type your message here ..",
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .15,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                          bottomLeft: Radius.circular(0),
                          topLeft: Radius.circular(0),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .sendMessage(
                                  messageController.text, widget.friendData)
                              .then((value) {
                            print('Message sent successfully');
                            messageController.text = '';
                          }).catchError((onError) {
                            print('Error sending message :' + onError);
                          });

                          setState(() {});
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
          ],
        ));
  }
}
