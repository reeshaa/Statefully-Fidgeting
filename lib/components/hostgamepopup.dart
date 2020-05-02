import 'package:flutter/material.dart';
import 'package:statefully_fidgeting/screens/gameplay_tugofwar.dart';
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
  var uuid = Uuid();
  Future<int> createRoom(String _uid, String _password, String _name) async {
    final response = await http.get(
        'https://game-backend.glitch.me/createRoom/${_uid}/${_password}/${_name}');

    if (response.statusCode == 200) {
      print('Room created');

      Navigator.pop(context);
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => GamePlay_TugOfWar(gameId: _uid,isAdmin: true,)));
      return 200;
    } else if (response.statusCode == 400) {
      return 400;
    } else {
      throw Exception('Failed create room');
    }
  }

  _displayCreateDialog(BuildContext context) async {
    final String gameID = uuid.v4();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Do you want to host a game?'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //Text("Game ID : $gameID"),

                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: "Your Name",
                        prefixIcon: Icon(Icons.account_circle)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      } else if (value.length < 3) {
                        return 'Your name must be atleast 3 characters long';
                      } else if (value.length > 12) {
                        return 'Too long !';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: "Enter a Password",
                        prefixIcon: Icon(Icons.vpn_key)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You cannot leave this field empty';
                      } else if (value.length < 3) {
                        return 'Password must be atleast 3 characters long';
                      } else if (value.length > 12) {
                        return 'Too long !';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(
                  'Host',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  String password = _passwordController.text == ""
                      ? "password"
                      : _passwordController.text.trim();
                  String name = _nameController.text == ""
                      ? "id"
                      : _nameController.text.trim();
                  if (_formKey.currentState.validate()) {
                    createRoom(gameID, password, name);
                  }

                  //Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: Colors.black,
      child: InkWell(
        highlightColor: Colors.green,
        splashColor: Colors.blue,
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          _displayCreateDialog(context);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          height: 50,
          child: Center(
            child: Text(
              "HOST A NEW GAME",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
