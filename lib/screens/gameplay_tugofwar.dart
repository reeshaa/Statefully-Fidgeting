import 'package:flutter/material.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GamePlay_TugOfWar extends StatefulWidget {
  @override
  _GamePlay_TugOfWarState createState() => _GamePlay_TugOfWarState();
}

class _GamePlay_TugOfWarState extends State<GamePlay_TugOfWar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.pink, Colors.yellow]),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.pink, Colors.red[900]]),
                        border: Border.all(
                          color: Colors.red[900],
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    height: 150,
                    width: 500,
                    padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                    //color: Colors.red[400],
                    child: Center(
                        child: Text('TheRope widget gets rendered here')),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red[900],
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                    height: 400,
                    width: 500,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.yellow[900],
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          height: 100,
                          width: 400,
                          padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                          //color: Colors.red[400],
                          child:
                              Center(child: Text('The question appears here')),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
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
                      borderRadius: BorderRadius.circular(10)),
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
    return RaisedButton.icon(
        onPressed: _showModalSheet,
        icon: Icon(Icons.more_vert),
        label: Text("More options"));
  }
}
