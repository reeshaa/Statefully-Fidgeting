import 'dart:wasm';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:statefully_fidgeting/screens/gameplay_tugofwar.dart';

class WaitingRoom extends StatelessWidget {
  String gameId;
  bool isAdmin;
  String name;
  WaitingRoom({this.gameId, this.isAdmin, this.name});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultBottomBarController(
        child: WaitingroomWidget(
          gameId: gameId,
          isAdmin: isAdmin,
          name: name,
        ),
      ),
    );
  }
}

class WaitingroomWidget extends StatefulWidget {
  String gameId;
  bool isAdmin;
  String name;
  String password = '';

  WaitingroomWidget({this.gameId, this.isAdmin, this.name});
  @override
  _WaitingRoomWidgetState createState() => _WaitingRoomWidgetState();
}

_displayJoinDialog(
    BuildContext context, String _gameId, String _name, bool _isAdmin,String _teamname) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Confirm to start the game'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                'Join',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                // playLocalAsset();

                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => GamePlayScreen(
                              gameId: _gameId,
                              isAdmin: _isAdmin,
                              name: _name,
                              teamname: _teamname,
                            )));

                //Navigator.pop(context);
              },
            )
          ],
        );
      });
}

class _WaitingRoomWidgetState extends State<WaitingroomWidget>
    with SingleTickerProviderStateMixin {
  BottomBarController controller;
  bool hasJoined = false;
  String teamname = 'None';
  List<String> teamA = new List();
  List<String> teamB = new List();

  @override
  void initState() {
    super.initState();
    controller = BottomBarController(vsync: this, dragLength: 550, snap: true);
    getPlayersList(widget.gameId);
    getPlayersList(widget.gameId, teamname: 'B');
    getPlayersList(widget.gameId, teamname: 'A');
    if(widget.isAdmin)
    setState(() {
    hasJoined =true;
    teamname='A';
    
    playersList.remove(widget.name);
    });
  }

  String question = '';
  List<String> playersList = new List();
  CollectionReference teamref;
  //to get the list of players
  Future<void> getPlayerData() async {
    setState(() async {
      teamref = await Firestore.instance
          .collection('game1')
          .document(widget.gameId)
          .collection('players');
    });
  }

  Future<void> joinTeam(String _teamname) async {
    final response = await http.get(
        'https://game-backend.glitch.me/jointeam/${widget.gameId}/${_teamname}/${widget.name}');

    if (response.statusCode == 200) {
      print('Retrieved');
      setState(() {
        hasJoined = true;
        teamname = _teamname;
      });
      print(hasJoined);
    } else {
      throw Exception('Failed join room');
    }
    setState(() {
      getPlayersList(widget.gameId, teamname: 'A');
      getPlayersList(widget.gameId, teamname: 'B');
      getPlayersList(widget.gameId);
    });
  }

  Future<void> leaveTeam(String _teamname) async {
    final response = await http.get(
        'https://game-backend.glitch.me/leaveteam/${widget.gameId}/${_teamname}/${widget.name}');

    if (response.statusCode == 200) {
      print('Retrieved');
      setState(() {
        hasJoined = false;
        teamname = 'None';
      });
      print(hasJoined);
    } else {
      throw Exception('Failed join room');
    }
    setState(() {
      getPlayersList(widget.gameId, teamname: 'A');
      getPlayersList(widget.gameId, teamname: 'B');
      getPlayersList(widget.gameId);
    });
  }

  Future<void> getPlayersList(String _uid, {String teamname = 'all'}) async {
    final response = await http
        .get('https://game-backend.glitch.me/playerslist${teamname}/${_uid}');

    if (response.statusCode == 200) {
      print('Retrieved');
      var data = jsonDecode(response.body);
      List<dynamic> names = data;
      // print(data);
      if (teamname == 'A') {
        await setState(() {
          this.teamA = names.map((item) => item.toString()).toList();
        });
        print(teamA);
      } else if (teamname == 'B') {
        await setState(() {
          this.teamB = names.map((item) => item.toString()).toList();
        });
        print(teamB);
      } else {
        await setState(() {
          this.playersList = names.map((item) => item.toString()).toList();
          this.playersList.removeWhere((player) =>
              this.teamA.contains(player) || this.teamB.contains(player));
        });
        print(this.playersList);
      }
    } else if (response.statusCode == 201) {
      print('Wrong Password');
    } else {
      throw Exception('Failed join room');
    }
  }

  Future<void> _startGame()async{
    final response = await http
        .get('https://game-backend.glitch.me/startgame/${widget.gameId}');

    if (response.statusCode == 200) {
      print('Game start');
      
    } else if (response.statusCode == 700) {
      print('Not all players joined teams');
    } else {
      throw Exception('Failed to start game');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultBottomBarController(
            child: Scaffold(
                body: StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance
                        .collection('game1')
                        .document(widget.gameId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();

                      if (snapshot.hasData) {
                        var docs =
                            snapshot.data.data; //stpring all gamedata here

                        // when the waiting toggle is switched
                        if (docs['isWaiting'] == false) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.lightGreenAccent[700],
                                    Colors.white
                                  ]),
                            ),
                            child: Center(
                                child: FlatButton(
                              child: Text("TAP TO START"),
                              onPressed: () => _displayJoinDialog(context,
                                  widget.gameId, widget.name, widget.isAdmin,teamname),
                            )),
                          );
                        }

                        /////////////////////////WAITING SCREEN , make changes here only
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.lightGreenAccent[700],
                                  Colors.white
                                ]),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Container(
                                child: CustomScrollView(
                                  /// THIS IS A CUSTOM SCROLL VIEW
                                  slivers: <Widget>[
                                    ////IF THERE'S A WIDGET U WANT TO PUT THAT DOESN'T HAVE THE WORD sliver in it, THEN WRAP IT WITH A SLIVER BOX ADAPTER
                                    SliverToBoxAdapter(
                                      child: Container(
                                        height: 150,
                                        width: 500,
                                        padding:
                                            EdgeInsets.fromLTRB(8, 10, 8, 10),
                                        //color: Colors.red[400],
                                        child: Center(
                                            child: Text(
                                                "Waiting for Players to join the Lobby")),
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child: ListTile(
                                        title: Text(
                                          "Team A",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        trailing: hasJoined
                                            ? teamname == 'A'
                                                ? FlatButton(
                                                    child: Text("Leave"),
                                                    onPressed: () async {
                                                      await leaveTeam('A');
                                                    },
                                                  )
                                                : Container(
                                                    height: 0,
                                                    width: 0,
                                                  )
                                            : FlatButton(
                                                child: Text("Join"),
                                                onPressed: () async {
                                                  await joinTeam('A');
                                                },
                                              ),
                                      ),
                                    ),
                                    /////THIS IS THE GRID FOR THE LIST OF PLAYERS
                                    SliverGrid(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            return Container(
                                                alignment: Alignment.center,
                                                child: ListTile(
                                                  //////// REPLACE THIS WITH A NICE LOOKING CARD
                                                  leading: CircleAvatar(
                                                    radius: 25,
                                                    child: Image.network(
                                                        'https://robohash.org/${teamA[index]}?set=set4'),
                                                  ),
                                                  title: Text(
                                                    teamA[index],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  onTap: () {
                                                    //LEAVE THIS TO ME
                                                  },
                                                ));
                                          },
                                          childCount: teamA.length,
                                        )),
                                    SliverToBoxAdapter(
                                      child: ListTile(
                                        title: Text(
                                          "Team B",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        trailing: hasJoined
                                            ? teamname == 'B'
                                                ? FlatButton(
                                                    child: Text("Leave"),
                                                    onPressed: () async {
                                                      await leaveTeam('B');
                                                    },
                                                  )
                                                : Container(
                                                    height: 0,
                                                    width: 0,
                                                  )
                                            : FlatButton(
                                                child: Text("Join"),
                                                onPressed: () async {
                                                  await joinTeam('B');
                                                },
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
                                                child: ListTile(
                                                  //////// REPLACE THIS WITH A NICE LOOKING CARD
                                                  leading: CircleAvatar(
                                                    radius: 35,
                                                    child: Image.network(
                                                        'https://robohash.org/${teamB[index]}?set=set4'),
                                                  ),
                                                  title: Text(
                                                    teamB[index],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  onTap: () {
                                                    //LEAVE THIS TO ME
                                                  },
                                                ));
                                          },
                                          childCount: teamB.length,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );

                        /////////END OF WAITING SCREEN   , CHECK BELOW FOR THE NAVBAR THING
                      }
                    }),

                // Lets use docked FAB for handling state of sheet
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                extendBody: true,

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

                ////////NAVBAR STARTS HERE
                bottomNavigationBar: PreferredSize(
                  preferredSize: Size.fromHeight(controller.dragLength),
                  // Size.fromHeight(controller.state.value * controller.dragLength),
                  child: BottomExpandableAppBar(
                    // Provide the bar controller in build method or default controller as ancestor in a tree
                    controller: controller,
                    expandedHeight: controller.dragLength,
                    horizontalMargin: 0.0,
                    attachSide: Side.Top,
                    expandedBackColor: Theme.of(context).backgroundColor,
                    // Your bottom sheet code here
                    expandedBody: CustomScrollView(slivers: <Widget>[
                      SliverToBoxAdapter(child: widget.isAdmin?ListTile(leading: Icon(MaterialCommunityIcons.xbox),title: Text("Start Game"),):Container(height: 0,width: 0),),
                      
                      SliverToBoxAdapter(child: widget.isAdmin?ListTile(leading: Icon(MaterialCommunityIcons.xbox),title: Text("Start Game",style: TextStyle(fontSize: 25),),onTap:(){
                        _startGame();
                      } ,):Container(height: 0,width: 0),),
                      SliverToBoxAdapter(child: ListTile(leading: Icon(Icons.supervisor_account),title: Text("List of players who haven't joined a team"),),),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      

                          return ListTile(
                            title: Text(playersList[index]),
                          );
                        },
                        childCount: playersList?.length ?? 0,
                      )),
                    ]),
                    // shape: AutomaticNotchedShape(
                    //     RoundedRectangleBorder(),
                    //     StadiumBorder(
                    //         side: BorderSide())), // Your bottom app bar code here
                    bottomAppBarBody: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.exit_to_app),
                              FlatButton(
                                child: Text("Leave Lobby"),
                                onPressed: () {
                                  //leave game
                                },
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.supervisor_account),
                              Text(
                                  '${(playersList.length + teamA.length + teamB.length)} joined')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )

                //////////NAVBAR ENDS HERE

                )));
  }
}
