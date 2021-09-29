import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social/componentes/default_text_field.dart';
import 'package:social/models/user_model.dart';
import 'package:social/providers/loading_provider.dart';
import 'package:social/providers/storage_provider.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  final UserModel user;

  EditProfileScreen({required this.user});


  @override
  Widget build(BuildContext context) {
    // Provider.of<StorageProvider>(context).usernameController.text =
    //     user.username;
    // Provider.of<StorageProvider>(context).bioController.text = user.bio;
    // Provider.of<StorageProvider>(context).phoneController.text = user.phone;

    return Scaffold(
        /*floatingActionButton: FloatingActionButton(onPressed: () {
           print(Provider.of<StorageProvider>(context,listen: false).usernameController.text);
        }),*/
        appBar: AppBar(
          title: Text(" Edit Profile"),
          actions: [
            TextButton(
              onPressed: () async {
                Provider.of<LoadingProvider>(context, listen: false)
                    .startUpdateLoading();
                await Provider.of<StorageProvider>(context, listen: false)
                    .updateUserData(context, user)
                    .then((value) {
                  Provider.of<LoadingProvider>(context, listen: false)
                      .finishUpdateLoading();

                  Navigator.pop(context);
                });
              },
              child: Text("UPDATE"),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Provider.of<LoadingProvider>(context).updateLoading
                    ? LinearProgressIndicator()
                    : Container(),
                SizedBox(
                  height: 5,
                ),
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
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Provider.of<StorageProvider>(context)
                                              .coverImage ==
                                          null
                                      ? Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            user.cover,
                                          ),
                                        )
                                      : Image.file(
                                          File(
                                            Provider.of<StorageProvider>(
                                                    context)
                                                .coverImage!
                                                .path,
                                          ),
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue[900],
                                  child: IconButton(
                                    onPressed: () async {
                                      await Provider.of<StorageProvider>(
                                        context,
                                        listen: false,
                                      ).pickCoverImage();
                                    },
                                    icon: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: Provider.of<StorageProvider>(
                                              context)
                                          .profileImage ==
                                      null
                                  ? NetworkImage(
                                      user.image,
                                    )
                                  : FileImage(
                                      File(
                                        Provider.of<StorageProvider>(context)
                                            .profileImage!
                                            .path,
                                      ),
                                    ) as ImageProvider,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue[900],
                              child: IconButton(
                                onPressed: () async {
                                  await Provider.of<StorageProvider>(
                                    context,
                                    listen: false,
                                  ).pickProfileImage();
                                },
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                DefaultTextField(
                  controller:
                      Provider.of<StorageProvider>(context).usernameController,
                  labelText: "Name",
                  hintText: user.username,

                  prefixIcon: Icon(
                    Icons.person,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DefaultTextField(
                  controller:
                      Provider.of<StorageProvider>(context).bioController,
                  labelText: "Bio",
                  hintText: user.bio,

                  prefixIcon: Icon(
                    Icons.info_outline,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DefaultTextField(
                  controller:
                      Provider.of<StorageProvider>(context).phoneController,
                  labelText: "Phone",
                  hintText: user.phone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    Icons.phone_android,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
