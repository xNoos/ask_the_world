// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ask_the_world/login.dart';
import 'package:ask_the_world/replies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Questions extends StatefulWidget {
  const Questions({Key key}) : super(key: key);

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  List questions = [];

  var name;
  bool isBoy = false, load = false;

  getUserData() async {
    setState(() {
      load = true;
    });
    SharedPreferences sp = await SharedPreferences.getInstance();

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(sp.getString('id'))
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        name = ds["name"];
        isBoy = ds["isBoy"];
      });
    });
    setState(() {
      load = false;
    });
  }

  getQuestions() async {
    setState(() {
      load = true;
    });
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("Questions").get();
    setState(() {
      load = false;
    });
    return qs.docs;
  }

  listen() {
    FirebaseFirestore.instance
        .collection("Questions")
        .snapshots()
        .listen((event) {
      getQuestions().then((data) => setState(() => questions = data));
    });
  }

  @override
  void initState() {
    super.initState();
    Jiffy.locale('ar');
    getUserData();
    listen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
                color: HexColor('#21364f'),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                )),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () async {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          sp.setString('id', '').then((value) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (builder) => Login()),
                                (route) => false);
                          });
                        },
                        icon: Icon(Icons.exit_to_app),
                        iconSize: 40,
                        color: Colors.white,
                      ),
                      load
                          ? SpinKitThreeBounce(color: Colors.white)
                          : Text(
                              '${questions.length}\nأسئلة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.white,
                                  fontFamily: 'myFont'),
                            )
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'قائمة الأسئلة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40.0,
                            color: Colors.white,
                            fontFamily: 'myFont'),
                      ),
                      InkWell(
                        onTap: () => addQuestion(),
                        child: Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          load
              ? SpinKitThreeBounce(color: Colors.white)
              : Container(
                  padding: EdgeInsets.only(top: 170),
                  margin: EdgeInsets.only(top: 20),
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 20, top: 20),
                      itemCount: questions.length,
                      itemBuilder: (_, index) {
                        DateTime qDate = DateTime.parse(
                            questions[index]['date'].toDate().toString());
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => Replies(
                                      questions[index]['id'],
                                      questions[index]['name'],
                                      DateFormat.yMMMd().format(qDate),
                                      questions[index]['question'],
                                      questions[index]['isBoy'],
                                      Jiffy(qDate).fromNow()))),
                          child: Card(
                            elevation: 25,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            shadowColor: Colors.black,
                            color: HexColor('#21364f'),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          margin: EdgeInsets.only(
                                              right: 10,
                                              top: 5,
                                              bottom: 5,
                                              left: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: HexColor('#21364f')),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(1),
                                                    blurRadius: 5,
                                                    spreadRadius: 1)
                                              ],
                                              image: DecorationImage(
                                                  image: AssetImage(questions[
                                                          index]['isBoy']
                                                      ? 'assets/images/boyAvatar.png'
                                                      : 'assets/images/girlAvatar.png'),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                questions[index]['name']
                                                    .toString(),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.white,
                                                    fontFamily: 'myFont'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                DateFormat.yMMMd()
                                                    .format(qDate),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey,
                                                    fontFamily: 'myFont'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 80,
                                        color: Colors.red[900],
                                        child: Text(
                                          Jiffy(qDate).fromNow(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.white,
                                              fontFamily: 'myFont'),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 60, left: 20),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        questions[index]['question'],
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                            fontFamily: 'myFont'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
        ],
      ),
    );
  }

  addQuestion() {
    TextEditingController controller = TextEditingController();
    return showModalBottomSheet(
        isScrollControlled: true,
        elevation: 20,
        backgroundColor: HexColor('#21364f'),
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        )),
        builder: (context) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 30, right: 10, left: 10, bottom: 50),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  style: TextStyle(
                      fontFamily: 'myFont',
                      fontSize: 25.0,
                      color: Colors.white),
                  decoration: InputDecoration(
                      labelText: 'اكتب السؤال هنا ...',
                      labelStyle: TextStyle(
                          fontFamily: 'myFont',
                          fontSize: 25.0,
                          color: Colors.white),
                      prefixIcon:
                          Icon(Icons.textsms_outlined, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    onPressed: () => _addQuestion(controller),
                    child: Text(
                      'إرسال السؤال',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                          fontFamily: 'myFont'),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  _addQuestion(controller) async {
    var id = DateTime.now().microsecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection("Questions").add({
      "name": name,
      "date": DateTime.now(),
      "question": controller.text,
      "isBoy": isBoy,
      "id": id
    }).then((value) {
      Navigator.of(context).pop();
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    });
  }
}
