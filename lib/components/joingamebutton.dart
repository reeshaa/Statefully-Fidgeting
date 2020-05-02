import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ffi';

class JoinGamePopup extends StatefulWidget {
  JoinGamePopup({Key key}) : super(key: key);

  @override
  _JoinGamePopupState createState() => _JoinGamePopupState();
}

class _JoinGamePopupState extends State<JoinGamePopup> {
 

  Future<void> joinRoom(String _uid, String _password, String _name) async {
    final response = await http.get(
        'https://game-backend.glitch.me/joinRoom/${_uid}/${_password}/${_name}');

    if (response.statusCode == 200) {
      print('Joined');
      Navigator.pop(context);

      return 200;
    } else if (response.statusCode == 201) {
      //return 400;
      print('Wrong Password');
    } else {
      throw Exception('Failed join room');
    }
  }

  _displayJoinDialog(BuildContext context) async {
    TextEditingController _idController = TextEditingController();
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
            title: Text('Enter Room ID and password'),
            content: Form(
              key:_formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: "Enter your name",
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
                    controller: _idController,
                    decoration: InputDecoration(
                        hintText: "Enter Room ID",
                        prefixIcon: Icon(Icons.confirmation_number)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the room ID';
                      } 
                      
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: "Enter a Pasword",
                        prefixIcon: Icon(Icons.vpn_key)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the passsword';
                      } else if (value.length < 3) {
                        return 'Your name must be atleast 3 characters long';
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
                  'Join',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  String password = _passwordController.text == ""
                      ? "password"
                      : _passwordController.text.trim();
                  String gameID = _idController.text == ""
                      ? "id"
                      : _idController.text.trim();
                  String name = _nameController.text == ""
                      ? "id"
                      : _nameController.text.trim();
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Verifying details')));
                    joinRoom(gameID, password, name);
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
    return Scaffold(
        body: Column(children: <Widget>[
      RaisedButton(
        child: Text('mhhmmm'),
        onPressed: () => _displayJoinDialog(context),
      ),
     
    ]));
  }
}
