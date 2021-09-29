import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social/componentes/chat_list_tile.dart';
import 'package:social/models/user_model.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/providers/layout_provider.dart';

class ChatsScreen extends StatefulWidget {
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: Provider.of<AuthProvider>(context).getChats(),
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData ) {

          if (snapshot.data!.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No chats yet.',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      /*  Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => UsersScreen()));*/
                      Provider.of<LayoutProvider>(context, listen: false)
                          .setCurrentIndex(3);
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      'Make Friends',
                    ),
                  ),
                ],
              ),
            );
          }
          else{
            print(snapshot.data![0].uid);
          print(snapshot.data!.length);
            return SmartRefresher(
            controller: _refreshController,
            onRefresh: () {
              setState(() {});
              _refreshController.refreshCompleted();
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ChatListTile(userData: snapshot.data![index]);
                  },
                  separatorBuilder: (context, index) {
                    return Container(height: .5, color: Colors.grey);
                  },
                  itemCount: snapshot.data!.length,
                ),
              ),
            ),
          );
        } }else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
