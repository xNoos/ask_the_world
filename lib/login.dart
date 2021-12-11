// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ask_the_world/questions.dart';
import 'package:ask_the_world/sginup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isBoy = true, vis = true, load = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 320,
              decoration: BoxDecoration(
                  color: HexColor('#21364f'),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 100),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'تسجيل دخول',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontFamily: 'myFont'),
                    ),
                  ),
                  SizedBox(height: 30),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 65),
                        child: Card(
                          elevation: 20,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 15, top: 80),
                            child: Column(
                              children: [
                                TextField(
                                  controller: email,
                                  style: TextStyle(
                                      fontSize: 22.0, fontFamily: 'myFont'),
                                  textDirection: TextDirection.ltr,
                                  decoration: InputDecoration(
                                      labelText: 'البريد الإلكتروني',
                                      prefixIcon: Icon(Icons.email),
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)))),
                                ),
                                SizedBox(height: 15),
                                TextField(
                                  controller: password,
                                  style: TextStyle(
                                      fontSize: 22.0, fontFamily: 'myFont'),
                                  obscureText: vis,
                                  decoration: InputDecoration(
                                      labelText: 'كلمة المرور',
                                      prefixIcon: Icon(Icons.lock),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            vis = !vis;
                                          });
                                        },
                                        child: Icon(vis
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                      contentPadding: EdgeInsets.only(),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)))),
                                ),
                                SizedBox(height: 10),
                                InkWell(
                                  child: Text(
                                    'نسيت كلمة المرور؟',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontFamily: 'myFont'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: HexColor('#21364f'),
                              shape: BoxShape.circle),
                          child: Stack(
                            children: [
                              Transform.translate(
                                offset: Offset(15, -10),
                                child: CircleAvatar(
                                  backgroundColor: HexColor('#21364f'),
                                  radius: 40,
                                  child: Image.asset(
                                      'assets/images/girlAvatar.png'),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(-15, 10),
                                child: CircleAvatar(
                                  backgroundColor: HexColor('#21364f'),
                                  radius: 40,
                                  child: Image.asset(
                                      'assets/images/boyAvatar.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(23))),
                      color: HexColor('#21364f'),
                      onPressed: () => load ? null : _login(),
                      child: load
                          ? SpinKitThreeBounce(color: Colors.white)
                          : Text(
                              'دخول',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35.0,
                                  fontFamily: 'myFont'),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Signup())),
                    child: Text(
                      'ليس لديك حساب؟ إنشاء حساب جديد',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'myFont'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _login() async {
    setState(() {
      load = true;
    });
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.text, password: password.text)
        .then((value) async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('id', value.user.uid);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Questions()),
          (route) => false);
    }).catchError((e) {
      setState(() {
        load = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        e.code,
        textAlign: TextAlign.center,
      )));
    });
    setState(() {
      load = false;
    });
  }
}
