import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ffi';

import 'package:url_launcher/url_launcher.dart';
import 'package:extended_navbar_scaffold/extended_navbar_scaffold.dart';
import 'package:vsync_provider/vsync_provider.dart';

class GamePlayScreen extends StatelessWidget {
  String gameId;
  bool isAdmin;
  String name;
  GamePlayScreen({this.gameId, this.isAdmin, this.name});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultBottomBarController(
        child: GamePlay_TugOfWar(
          gameId: gameId,
          isAdmin: isAdmin,
          name: name,
        ),
      ),
    );
  }
}

class GamePlay_TugOfWar extends StatefulWidget {
  String gameId;
  bool isAdmin;
  String name;
  GamePlay_TugOfWar({this.gameId, this.isAdmin, this.name});
  @override
  _GamePlay_TugOfWarState createState() => _GamePlay_TugOfWarState();
}

class _GamePlay_TugOfWarState extends State<GamePlay_TugOfWar>
    with SingleTickerProviderStateMixin {
  BottomBarController controller;

  @override
  void initState() {
    super.initState();
    controller = BottomBarController(vsync: this, dragLength: 550, snap: true);
    questionGetter();
    getPlayersList(widget.gameId);
  }

  String question = '';
  List<String> playersList = new List();
  Future<void> questionGetter() async {
    final response =
        await http.get('https://game-backend.glitch.me/TOG/GiveQuestion');

    if (response.statusCode == 200) {
      print('Joined');
      print(response.body);
      setState(() {
        question = response.body;
      });
      return 200;
    } else if (response.statusCode == 201) {
      //return 400;
      print('Wrong Password');
    } else {
      throw Exception('Failed join room');
    }
  }

//submitting response
  Future<void> submitAnswer(String _option) async {
    final response = await http.get(
        'https://game-backend.glitch.me/optionselect/${widget.gameId}/${widget.name}/${_option}');

    if (response.statusCode == 200) {
      print('Joined');
      print(response.body);
      setState(() {
        question = response.body;
      });
      return 200;
    } else if (response.statusCode == 201) {
      //return 400;
      print('Wrong Password');
    } else {
      throw Exception('Failed join room');
    }
  }

  //to get the list of players
  Future<void> getPlayersList(String _uid) async {
    final response =
        await http.get('https://game-backend.glitch.me/playerslist/${_uid}');

    if (response.statusCode == 200) {
      print('Retrieved');
      var data = jsonDecode(response.body);
      List<dynamic> names = data;
      // print(data);

      await setState(() {
        this.playersList = names.map((item) => item.toString()).toList();
      });
      print(playersList);
    } else if (response.statusCode == 201) {
      print('Wrong Password');
    } else {
      throw Exception('Failed join room');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultBottomBarController(
            child: Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.lightGreenAccent[700], Colors.white]),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Container(
                        /* decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.pink, Colors.red[900]]),
                        border: Border.all(
                          color: Colors.red[900],
                        ),
                        borderRadius: BorderRadius.circular(10)),*/
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                              child: Container(
                                height: 150,
                                width: 500,
                                padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                //color: Colors.red[400],
                                child: Center(
                                    child: Text(
                                        'TheRope widget gets rendered here')),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.lightGreenAccent[700],
                                      width: 15,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                //padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                height: 150,
                                width: 500,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.limeAccent[400],
                                        width: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 150,
                                  width: 400,
                                  //padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                  //color: Colors.red[400],
                                  child: Center(
                                      child: Text(
                                    '${question}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 22,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                            SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            height: 150,
                                            width: 300,
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: InkWell(
                                                onTap: () {
                                                  submitAnswer(
                                                      playersList[index]);
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      radius: 30,
                                                      child: Image.network(
                                                          'https://robohash.org/${playersList[index]}?set=set4'),
                                                    ),
                                                    SizedBox(height: 12),
                                                    // title:
                                                    Text(
                                                      playersList[index],
                                                      style: TextStyle(
                                                        fontSize: 26,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )));
                                  },
                                  childCount: playersList.length,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Lets use docked FAB for handling state of sheet
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                extendBody: true,
                // appBar: AppBar(
                //   title: Text("Panel Showcase"),
                //   backgroundColor: Theme.of(context).bottomAppBarColor,
                // ),

                // Lets use docked FAB for handling state of sheet
                floatingActionButton: GestureDetector(
                  // Set onVerticalDrag event to drag handlers of controller for swipe effect
                  onVerticalDragUpdate: controller.onDrag,
                  onVerticalDragEnd: controller.onDragEnd,
                  child: FloatingActionButton.extended(
                    label: Text("Pull up"),
                    elevation: 2,
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,

                    //Set onPressed event to swap state of bottom bar
                    onPressed: () => controller.swap(),
                  ),
                ),
                bottomNavigationBar: PreferredSize(
                  preferredSize: Size.fromHeight(controller.dragLength),
                  // Size.fromHeight(controller.state.value * controller.dragLength),
                  child: BottomExpandableAppBar(
                    // Provide the bar controller in build method or default controller as ancestor in a tree
                    controller: controller,
                    appBarHeight: 55,
                    expandedHeight: 70,

                    //expandedHeight: controller.dragLength,
                    horizontalMargin: 0,
                    attachSide: Side.Top,
                    expandedBackColor: Colors.white,
                    // expandedBackColor: Theme.of(context).backgroundColor,
                    // Your bottom sheet code here
                    expandedBody: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(top: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              width: 120,
                              child: RaisedButton.icon(
                                  color: Colors.black,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.backspace,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: Text(
                                    "Quit Game",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                  size: 30,
                                ),
                                onPressed: () {}),
                            Container(
                              width: 120,
                              child: RaisedButton.icon(
                                  color: Colors.black,
                                  onPressed: _launchURL,
                                  icon: Icon(
                                    Icons.group_add,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  label: Text(
                                    "Invite",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // shape: AutomaticNotchedShape(
                    //     RoundedRectangleBorder(),
                    //     StadiumBorder(
                    //         side: BorderSide())), // Your bottom app bar code here
                    bottomAppBarBody: Padding(
                      padding: const EdgeInsets.all(02.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(AntDesign.Trophy),
                              SizedBox(width: 5),
                              Text("4th")
                            ],
                          ),
                          SizedBox(width: 5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(MaterialCommunityIcons.xbox_controller),
                              SizedBox(width: 5),
                              Text("Round 1")
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ))));
  }
}

_launchURL() async {
  const url =
      "https://wa.me/?text=Join%20a%20game%20of%20'TUG%20OF%20WAR'%20on%20Statefully%20Fidgeting.\n\nGAME%20ID  :%20here\nPASSWORD :%20here";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
