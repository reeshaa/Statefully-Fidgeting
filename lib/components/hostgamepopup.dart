import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class HostGamePopup extends StatefulWidget {
  HostGamePopup({Key key}) : super(key: key);

  @override
  _HostGamePopupState createState() => _HostGamePopupState();
}

class _HostGamePopupState extends State<HostGamePopup> {
  TextEditingController _passwordController = TextEditingController();
  var uuid = Uuid();
  
  _displayDialog(BuildContext context) async {
    final String gameID=uuid.v4();  
    
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
          
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Text('Game ID : $gameID'),
            content: 
            Column(children: <Widget>[
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
              controller: _passwordController,
              decoration: InputDecoration(hintText: "\u20B9 10.00"),
            ),
            Text("hi"),
            ],),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Add Item to Store',style: TextStyle(color: Colors.green),),
                onPressed: () {
                  
                  Navigator.of(context).pop();
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