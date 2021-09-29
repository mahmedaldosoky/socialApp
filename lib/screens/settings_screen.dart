// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/user_model.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/screens/edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .27,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .22,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(Provider.of<AuthProvider>(context)
                            .currentUserData!
                            .cover),
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 64,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      Provider.of<AuthProvider>(context).currentUserData!.image,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            Provider.of<AuthProvider>(context).currentUserData!.username,
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            Provider.of<AuthProvider>(context).currentUserData!.bio,
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "100",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18),
                    ),
                    Text(
                      "Posts",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "65",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18),
                    ),
                    Text(
                      "Photos",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "26",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18),
                    ),
                    Text(
                      "Followers",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "95",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18),
                    ),
                    Text(
                      "Following",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {},
                  child: Text('Add Photos'),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              OutlinedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => EditProfileScreen(
                                user: Provider.of<AuthProvider>(context)
                                    .currentUserData as UserModel,
                              ))).then((value) async {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .getCurrentUserData();
                    setState(()  {

                    }); // update data after pop up from edit profile screen
                  });
                },
                child: Icon(
                  Icons.edit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
