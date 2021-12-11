// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Replies extends StatefulWidget {
  var id, name, date, question, isBoy, since;
  Replies(this.id, this.name, this.date, this.question, this.isBoy, this.since);
  @override
  _RepliesState createState() =>
      _RepliesState(id, name, date, question, isBoy, since);
}

class _RepliesState extends State<Replies> {
  var id, name, date, question, isBoy, since;
  _RepliesState(
      this.id, this.name, this.date, this.question, this.isBoy, this.since);
  List replies = [];
  bool load = false;
  TextEditingController _answer = TextEditingController();

  getReplies() async {
    setState(() {
      load = true;
    });
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Replies")
        .where('id', isEqualTo: id)
        .get();
    setState(() {
      load = false;
    });
    return qs.docs;
  }

  listen() {
    FirebaseFirestore.instance
        .collection("Replies")
        .snapshots()
        .listen((event) {
      getReplies().then((data) => setState(() => replies = data));
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    listen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            decoration: BoxDecoration(
              color: HexColor('#21364F'),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            height: MediaQuery.of(context).size.height / 2.5,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 20, top: 8),
                  child: load
                      ? SpinKitThreeBounce(color: Colors.white)
                      : Text(
                          "${replies.length}\nردود",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'myFont'),
                        ),
                ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Container(
              margin: const EdgeInsets.fromLTRB(16.0, 30.0, 16, 8),
              decoration: BoxDecoration(
                  color: const Color(0xffE6E9F4),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ]),
              // padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 4.0, right: 4.0, top: 4, bottom: 0.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: HexColor('#21364F'),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ]
                        // color: Color.fromRGBO(64, 75, 96, .9),
                        ),
                    padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Image.asset(
                                isBoy
                                    ? "assets/images/boyAvatar.png"
                                    : "assets/images/girlAvatar.png",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: const Color(0xff21364F), width: 2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      fontFamily: 'myFont'),
                                ),
                                SizedBox(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      date,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                          fontFamily: 'myFont'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 80,
                              color: Colors.red[900],
                              child: Text(
                                since,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.white,
                                    fontFamily: 'myFont'),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 28),
                          child: SizedBox(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                question,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontFamily: 'myFont'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  load
                      ? SpinKitThreeBounce(color: Colors.black)
                      : Flexible(
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 20),
                            physics:
                                const AlwaysScrollableScrollPhysics(), // new
                            children: List.generate(replies.length, (index) {
                              DateTime rDate = DateTime.parse(
                                  replies[index]['date'].toDate().toString());

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  index == 0
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(right: 30),
                                          width: 3,
                                          height: 30,
                                          color: Colors.black,
                                        )
                                      : Container(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 30),
                                        width: 3,
                                        height: index == replies.length - 1
                                            ? 76 / 2
                                            : 76,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 15,
                                              height: 3,
                                              color: Colors.black,
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 65,
                                                margin: const EdgeInsets.only(
                                                    left: 4.0,
                                                    right: 0,
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color: const Color(
                                                          0xff21364F),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color:
                                                        const Color(0xffF4F6FD),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: const Offset(0,
                                                            0), // changes position of shadow
                                                      ),
                                                    ]),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 4, 12, 0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Image.asset(
                                                            replies[index][
                                                                        "isBoy"] ==
                                                                    true
                                                                ? "assets/images/boyAvatar.png"
                                                                : "assets/images/girlAvatar.png",
                                                            height: 30,
                                                            width: 30,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        1),
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                                offset: const Offset(
                                                                    0,
                                                                    0), // changes position of shadow
                                                              ),
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            border: Border.all(
                                                                color: const Color(
                                                                    0xff21364F),
                                                                width: 1),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          replies[index]["name"]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 17.0,
                                                              fontFamily:
                                                                  'myFont'),
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 4,
                                                          ),
                                                          child: Icon(
                                                            Icons.circle,
                                                            size: 5,
                                                          ),
                                                        ),
                                                        Text(
                                                          Jiffy(rDate)
                                                              .fromNow()
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12.0,
                                                              fontFamily:
                                                                  'myFont'),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .only(start: 0),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Text(
                                                          replies[index]
                                                                  ["answer"]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13.0,
                                                              fontFamily:
                                                                  'myFont'),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              );
                            }),
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 24, top: 8),
                                  child: Text(
                                    "ردك أو إجابتك...",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17.0,
                                        fontFamily: 'myFont'),
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _answer,
                              maxLength: 45,
                              style:
                                  TextStyle(fontFamily: 'myFont', fontSize: 18),
                              decoration: InputDecoration(
                                helperStyle: TextStyle(fontSize: 5),
                                isDense: true,
                                hintText: "أكتب هنا",
                                hintStyle: TextStyle(
                                    fontFamily: 'myFont', fontSize: 18),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                filled: true,
                                fillColor: Color(0xffE6E9F4),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                width: double.infinity,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  color: Colors.green.shade900,
                                  onPressed: () => addReplies(),
                                  child: Text(
                                    "رد",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                        fontFamily: 'myFont'),
                                  ),
                                )),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  var _name, _isBoy;

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
        _name = ds["name"];
        _isBoy = ds["isBoy"];
      });
    });
    setState(() {
      load = false;
    });
  }

  addReplies() async {
    await FirebaseFirestore.instance.collection("Replies").add({
      "name": _name,
      "isBoy": _isBoy,
      "date": DateTime.now(),
      "answer": _answer.text,
      "id": id
    }).then((value) {
      _answer.clear();
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        e.code,
        textAlign: TextAlign.center,
      )));
    });
  }
}
