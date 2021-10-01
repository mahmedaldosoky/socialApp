import 'package:flutter/material.dart';
import 'package:social/screens/chats_screen.dart';
import 'package:social/screens/home_screen.dart';
import 'package:social/screens/create_post_screen.dart';
import 'package:social/screens/settings_screen.dart';
import 'package:social/screens/users_screen.dart';

class LayoutProvider extends ChangeNotifier {
//Bottom navigation bar
  int _currentIndex = 0;

  int getCurrentIndex() => _currentIndex;

  void setCurrentIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  List<Widget> screens = [
    HomeScreen(),
    ChatsScreen(),
    CreatePostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> screensTitle = [
    "Home",
    "Chats",
   "Post",
    "Users",
    "Settings",
  ];
}
