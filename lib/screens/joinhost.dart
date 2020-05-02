import 'package:flutter/material.dart';

class JoinHostChoice extends StatefulWidget {
  JoinHostChoice({Key key}) : super(key: key);

  @override
  _JoinHostChoiceState createState() => _JoinHostChoiceState();
}

class _JoinHostChoiceState extends State<JoinHostChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.pink, Colors.yellow]),
          ),
          child: Center(
            child: Container(
              height: 300,
              padding: EdgeInsets.all(20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Let's Play!",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 32),
                      ),
                      SizedBox(height: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            color: Colors.pinkAccent,
                            child: InkWell(
                              highlightColor: Colors.green,
                              splashColor: Colors.blue,
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                print('clicked host');
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "HOST A NEW GAME",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            color: Colors.pinkAccent,
                            child: InkWell(
                              highlightColor: Colors.green,
                              splashColor: Colors.blue,
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                print('clicked join');
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "JOIN EXISTING GAME",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
