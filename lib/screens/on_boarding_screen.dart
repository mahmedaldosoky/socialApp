import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/screens/layout_screen.dart';
import 'package:social/screens/login_screen.dart';

import 'login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  final List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: "Title of first page",
      body:
          "Here you can write the description of the page, to explain someting...",
      image: Center(
          child: Image(
              image: NetworkImage(
                  "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/34999/woman-shopping-clipart-md.png"),
              height: 300.0)),
      decoration: const PageDecoration(
        pageColor: Colors.white,
      ),
    ),
    PageViewModel(
      title: "Title of Second page",
      body:
          "Here you can write the description of the page, to explain someting...",
      image: Center(
          child: Image(
              image: NetworkImage(
                  "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/34999/woman-shopping-clipart-md.png"),
              height: 300.0)),
      decoration: const PageDecoration(
        pageColor: Colors.white,
      ),
    ),
    PageViewModel(
      title: "Title of Third page",
      body:
          "Here you can write the description of the page, to explain someting...",
      image: Center(
          child: Image(
              image: NetworkImage(
                  "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/34999/woman-shopping-clipart-md.png"),
              height: 300.0)),
      decoration: const PageDecoration(
        pageColor: Colors.white,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Navigate to home if logged before
    if (Provider.of<AuthProvider>(context).auth.currentUser != null) {

      Future.delayed(Duration(seconds: 1),(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => LayoutScreen()),
              (route) => false,
        );
      }));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: IntroductionScreen(
            pages: listPagesViewModel,
            onDone: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(),
                ),
              );
            },
            onSkip: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(),
                ),
              );
            },
            showSkipButton: true,
            skip: const Text(
              "Skip",
              style: TextStyle(fontSize: 16),
            ),
            next: const Icon(Icons.navigate_next),
            done: const Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: Theme.of(context).primaryColor,
              color: Colors.grey,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
