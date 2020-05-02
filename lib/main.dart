import 'package:flutter/material.dart';
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
      body: Center(
        child: Column(
          children: <Widget>[
            Text("This is the home screen on main.dart"),
            RaisedButton(
              child: Text("Open Game screen"),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => GamePlay_TugOfWar()));
              },
            ),
            RaisedButton(
              child: Text("Open Join/Host screen"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => JoinHostChoice()));
              },
            ),
            RaisedButton(
              child: Text("Open Join/Host screen"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HostGamePopup()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
