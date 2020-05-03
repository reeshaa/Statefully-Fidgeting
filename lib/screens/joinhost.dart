import 'package:flutter/material.dart';
import 'package:statefully_fidgeting/components/hostgamepopup.dart';
import 'package:statefully_fidgeting/components/joingamebutton.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class JoinHostChoice extends StatefulWidget {
  JoinHostChoice({Key key}) : super(key: key);

  @override
  _JoinHostChoiceState createState() => _JoinHostChoiceState();
}

class _JoinHostChoiceState extends State<JoinHostChoice> {
  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("zapsplat_cartoon_ascending_blip_slip_44565.mp3");
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black : Colors.white;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(25, 25, 25, 1.0);
    Color dynamicslimecolor = (!isDarkMode)
        ? Colors.lightGreenAccent
        : Color.fromRGBO(25, 25, 25, 1.0);

    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 70,
          backgroundColor: Colors.black,
          elevation: 5,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              "TUG OF WAR!",
              style: TextStyle(color: Colors.white),
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                playLocalAsset();
                Navigator.pop(context);
              }),
        ),
        SliverFillRemaining(
          hasScrollBody: true,
          child: Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //       begin: Alignment.topRight,
            //       end: Alignment.bottomLeft,
            //       colors: [Colors.white10, Colors.white]),
            // ),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Let's Play!",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
                  ),
                  SizedBox(height: 20),
                  HostGamePopup(),
                  SizedBox(height: 20),
                  JoinGamePopup(),
                  SizedBox(height: 75),
                  SlimyCard(
                    color: dynamicslimecolor,
                    //color: Colors.lightGreenAccent,
                    width: 400,
                    topCardHeight: 150,
                    bottomCardHeight: 200,
                    borderRadius: 15,
                    topCardWidget: ListTile(
                      title: Text(
                        "How to Play",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(
                        Icons.info,
                        size: 50,
                        color: dynamiciconcolor,
                      ),
                    ),
                    bottomCardWidget: Text(
                      "Tug of War, is a game consisting of 2 teams with a maximum of 5 members per team.\n\nRandom questions are to be answered by the team members, and the team which knows its members well, wins!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    slimeEnabled: true,
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
