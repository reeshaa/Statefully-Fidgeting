import 'package:flutter/material.dart';
import 'package:statefully_fidgeting/screens/joinhost.dart';
import 'package:flutter/services.dart';
import 'package:statefully_fidgeting/components/hostgamepopup.dart';
import 'screens/gameplay_tugofwar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statefully Fidgeting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPageMain(),
    );
  }
}

class LandingPageMain extends StatefulWidget {
  LandingPageMain({Key key}) : super(key: key);

  @override
  _LandingPageMainState createState() => _LandingPageMainState();
}

class _LandingPageMainState extends State<LandingPageMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //       colors: [Colors.pink, Colors.yellow]),
        // ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "Statefully Fidgeting",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: Colors.lightGreenAccent[700],
              child: InkWell(
                highlightColor: Colors.green,
                splashColor: Colors.blue,
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => JoinHostChoice()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: Center(
                    child: Text(
                      "PLAY",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
