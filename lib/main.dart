import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/screens/signin_screen.dart';
import 'package:photomemo/screens/home_screen.dart';
import 'package:photomemo/screens/add_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PhotoMemoApp());
}

class PhotoMemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        AddScreen.routeName: (context) => AddScreen(),
      },
    );
  }
}
