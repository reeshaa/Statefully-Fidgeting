import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ffi';

class HostGamePopup extends StatefulWidget {
  HostGamePopup({Key key}) : super(key: key);

  @override
  _HostGamePopupState createState() => _HostGamePopupState();
}

class _HostGamePopupState extends State<HostGamePopup> {
  TextEditingController _passwordController = TextEditingController();
  var uuid = Uuid();
  Future<int> createRoom(String _uid,String _password) async {
    final response = await http
        .get('https://game-backend.glitch.me/createRoom/${_uid}/${_password}');
    
    
    if (response.statusCode == 200) {
      print('Room created');
      return 200;
          
          
          } 
    else if (response.statusCode==400){
      return 400;
    }
          else {

      throw Exception('Failed create room');
    }
  }
  
  _displayDialog(BuildContext context) async {
    final String gameID=uuid.v4();  
    
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
          
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Text('Do you want to host a game?'),
            content: 
            Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
            Text("Game ID : $gameID"),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              decoration: InputDecoration(hintText: "Enter a Pasword"),
            ),
            
            ],),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Host',style: TextStyle(color: Colors.green),),
                onPressed: () {
                  String password = _passwordController.text==""?"password" : _passwordController.text;
                  createRoom(gameID, password);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  
  @override
  Widget build(BuildContext context) {

    return Container(
      child:RaisedButton(child: Text('mhhmmm'),onPressed: ()=>
    _displayDialog(context),
    ));
  }
}