import 'package:flutter/material.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ffi';

class GamePlay_TugOfWar extends StatefulWidget {
  String gameId;
  bool isAdmin;
  String name;
  GamePlay_TugOfWar({this.gameId, this.isAdmin, this.name});
  @override
  _GamePlay_TugOfWarState createState() => _GamePlay_TugOfWarState();
}

class _GamePlay_TugOfWarState extends State<GamePlay_TugOfWar> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    questionGetter();
    getPlayersList(widget.gameId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => getPlayersList(widget.gameId),
        child: Icon(Icons.refresh),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.green[300], Colors.yellow[400]]),
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
                          child: Text('TheRope widget gets rendered here')),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.lightGreenAccent[700],
                            width: 20,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                      height: 100,
                      width: 500,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.yellow[900],
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        height: 100,
                        width: 400,
                        padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                        //color: Colors.red[400],
                        child: Center(child: Text('${question}')),
                      ),
                    ),
                  ),
                  SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                              alignment: Alignment.center,
                              child: ListTile(
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
                                  submitAnswer(playersList[index]);
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
      ),
      bottomSheet: BottomModal(),
    );
  }
}

class BottomModal extends StatefulWidget {
  String gameId;
  bool isAdmin;
  BottomModal({this.gameId, this.isAdmin});
  @override
  _BottomModalState createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {},
                  icon: Icon(Icons.group_add),
                  label: Text("Invite Players")),
            ),
            padding: EdgeInsets.all(40.0),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Row(children: <Widget>[
          RaisedButton.icon(
              onPressed: _showModalSheet,
              icon: Icon(
                Icons.more_vert,
              ),
              label: Text("More options")),
        ]));
  }
}
