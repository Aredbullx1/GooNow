import 'package:flutter/material.dart';
import '../../../../screens/search_screen.dart';
import '../../../../utils/universal_variables.dart';

class QuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Parece que no has hablado con nadie",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Busca a alguien con quien hablar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: UniversalVariables.lightBlueColor,
                child: Text("BUSCAR"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
