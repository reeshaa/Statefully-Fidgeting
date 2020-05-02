import 'package:flutter/material.dart';
import 'package:statefully_fidgeting/components/hostgamepopup.dart';
import 'package:statefully_fidgeting/components/joingamebutton.dart';

class JoinHostChoice extends StatefulWidget {
  JoinHostChoice({Key key}) : super(key: key);

  @override
  _JoinHostChoiceState createState() => _JoinHostChoiceState();
}

class _JoinHostChoiceState extends State<JoinHostChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          CustomScrollView(physics: BouncingScrollPhysics(), slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 70,
          backgroundColor: Colors.black,
          elevation: 5,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: Image.asset('image/war.jpg'),
            title: Text(
              "TUG OF WAR!",
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: true,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.pink, Colors.yellow]),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Game Description:",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Tug of War, is a game consisting of 2 teams with a maximum of 5 members per team. Random questions are to be answered by the team members, and the team which knows its members well, wins!",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Center(
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
                                    fontWeight: FontWeight.w700, fontSize: 28),
                              ),
                              SizedBox(height: 25),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  HostGamePopup(),
                                  SizedBox(height: 20),
                                  JoinGamePopup(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
