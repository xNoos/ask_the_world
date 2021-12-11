import 'package:ask_the_world/questions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences sp = await SharedPreferences.getInstance();
  var id = sp.getString('id');
  runApp(MyApp(id == '' || id == null ? false : true));
}

class MyApp extends StatelessWidget {
  bool loggedIn = false;
  MyApp(this.loggedIn);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
      ],
      locale: const Locale('ar', ''),
      title: 'Ask the world',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: loggedIn ? Questions() : Login(),
    );
  }
}
