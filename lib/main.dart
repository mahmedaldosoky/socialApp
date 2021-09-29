import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/providers/chat_provider.dart';
import 'package:social/providers/emit_provider.dart';
import 'package:social/providers/layout_provider.dart';
import 'package:social/providers/loading_provider.dart';
import 'package:social/providers/storage_provider.dart';
import 'package:social/screens/on_boarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<LayoutProvider>(
          create: (_) => LayoutProvider(),
        ),
        ChangeNotifierProvider<StorageProvider>(
          create: (_) => StorageProvider(),
        ),
        ChangeNotifierProvider<LoadingProvider>(
          create: (_) => LoadingProvider(),
        ),
        ChangeNotifierProvider<EmitProvider>(
          create: (_) => EmitProvider(),
        ),  ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
      ],
      child: OKToast(
        backgroundColor: Colors.green,
        position: ToastPosition.bottom,
        textStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.white,
            ),
        radius: 5,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: TextTheme(),
            fontFamily: "Cairo",
            primarySwatch: Colors.lightBlue,
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Theme.of(context).iconTheme.color,
              elevation: 0,
            ),
          ),
          themeMode: ThemeMode.light, // ThemeMode.system,
      //    home: Provider.of<AuthProvider>(context).currentUserData==null?OnBoardingScreen():LayoutScreen(),
         home: OnBoardingScreen(),
        ),
      ),
    );
  }
}
