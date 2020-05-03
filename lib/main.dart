import 'package:flutter/material.dart';
import 'package:statefully_fidgeting/screens/joinhost.dart';
import 'package:flutter/services.dart';
import 'package:statefully_fidgeting/components/hostgamepopup.dart';
import 'screens/gameplay_tugofwar.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Statefully Fidgeting',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        textTheme: TextTheme(
          title: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
          ),
          subtitle: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          body1: TextStyle(
            fontFamily: 'Quicksand',
          ),
          body2: TextStyle(
            fontFamily: 'Quicksand',
          ),
          button: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
          ),
          headline: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w600,
          ),
          display1: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          display2: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          display3: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          display4: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          overline: TextStyle(
            fontFamily: 'Quicksand',
          ),
          caption: TextStyle(
            fontFamily: 'Quicksand',
          ),
          subhead: TextStyle(
            fontFamily: 'Quicksand',
          ),
        ),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark, primarySwatch: Colors.deepOrange),
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
  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("tspt_game_button_04_040.mp3");
  }

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
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                fontFamily: 'Quicksand',
              ),
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
                  playLocalAsset();

                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => JoinHostChoice()));
                  //playLocalAsset();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: Center(
                    child: Text(
                      "PLAY!",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        fontFamily: 'Quicksand',
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
