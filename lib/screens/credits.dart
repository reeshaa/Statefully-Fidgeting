import 'package:flutter/material.dart';

class Credits extends StatefulWidget {
  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  /*bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

  Color dynamiciconcolor = (!isDarkMode) ? Colors.black : Colors.white;

  Color dynamicuicolor =
      (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(25, 25, 25, 1.0);

  Color dynamicslimecolor =
      (!isDarkMode) ? Colors.lightGreenAccent : Color.fromRGBO(25, 25, 25, 1.0);*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credits'),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.lightGreenAccent, Colors.white])),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                  'As we like to put it - a trio of widgets gone stateless in the lockdown, yet somehow managed to stay Statefully Fidgeting'),
              Divider(
                color: Colors.lightGreenAccent,
                thickness: 5,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Reesha                 Soundarya\n\n\n                Suraj',
                style: TextStyle(
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.lightGreenAccent[700],
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
