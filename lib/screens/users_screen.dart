import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/componentes/chat_list_tile.dart';
import 'package:social/models/user_model.dart';
import 'package:social/providers/auth_provider.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: Provider.of<AuthProvider>(context).getUsers(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          print(snapshot.data![0].uid);
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatListTile(
                    userData: snapshot.data![index],
                    trailing: Icon(
                      Icons.person_add_alt_1_outlined,
                      size: 30,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(height: .5, color: Colors.grey);
                },
                itemCount: snapshot.data!.length,
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
