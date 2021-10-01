import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/providers/layout_provider.dart';
import 'package:social/providers/loading_provider.dart';
import 'package:social/screens/create_post_screen.dart';


class LayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<AuthProvider>(context).currentUserData == null) {
      // Loading user data when you open the app
      Provider.of<AuthProvider>(context).getCurrentUserData();
    }

    int currentIndex = Provider.of<LayoutProvider>(context).getCurrentIndex();
    return !Provider.of<AuthProvider>(context).finishedLoadingUserData
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(/*
      floatingActionButton: FloatingActionButton(onPressed: () {
  Provider.of<LoadingProvider>(context).x();
            }),*/
            appBar: AppBar(
              title: Text(
                Provider.of<LayoutProvider>(context).screensTitle[currentIndex],
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: FaIcon(
                    FontAwesomeIcons.bell,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {},
                  icon: FaIcon(
                    FontAwesomeIcons.search,
                    color: Colors.black,
                    size: 21,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (int newIndex) {
                if (newIndex == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => CreatePostScreen(),
                    ),
                  );
                } else {
                  Provider.of<LayoutProvider>(context, listen: false)
                      .setCurrentIndex(newIndex);
                }
              },
              currentIndex: currentIndex,
              backgroundColor: Colors.deepOrange,
              selectedItemColor: Colors.lightBlue,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.inbox),
                  label: "Chats",
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.stickyNote),
                  label: "Post",
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.users),
                  label: "Users",
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.cog),
                  label: "Settings",
                ),
              ],
            ),
            body: Provider.of<LayoutProvider>(context).screens[currentIndex],
          );
  }
}
