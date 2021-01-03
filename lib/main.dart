import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sai_caterers/screens/home_screen.dart';

void main() async{
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 runApp(SaiApp());
}

class SaiApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RV Caterers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFF6D00),
        accentColor: Color(0xFFFFAB40),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: HomeScreen(),
    );
  }
}

