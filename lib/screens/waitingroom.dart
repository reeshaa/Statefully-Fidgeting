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
    BuildContext context, String _gameId, String _name, bool _isAdmin) async {
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

  @override
  void initState() {
    super.initState();
    controller = BottomBarController(vsync: this, dragLength: 550, snap: true);

    getPlayersList(widget.gameId);
  }

  String question = '';
  List<String> playersList = new List();

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
                              child: Text("Game has begun"),
                              onPressed: () => _displayJoinDialog(context,
                                  widget.gameId, widget.name, widget.isAdmin),
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
                                                '${docs['password']}   ${docs['isWaiting']}')),
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
                                                        'https://robohash.org/${playersList[index]}?set=set4'),
                                                  ),
                                                  title: Text(
                                                    playersList[index],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  onTap: () {
                                                    //LEAVE THIS TO ME
                                                  },
                                                ));
                                          },
                                          childCount: playersList.length,
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
                    horizontalMargin: 16,
                    attachSide: Side.Top,
                    expandedBackColor: Theme.of(context).backgroundColor,
                    // Your bottom sheet code here
                    expandedBody: Center(
                      child: Text("Hello world!"),
                    ),
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
                              Icon(AntDesign.Trophy),
                              Text("4th")
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(MaterialCommunityIcons.xbox_controller),
                              Text("Round 1")
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
