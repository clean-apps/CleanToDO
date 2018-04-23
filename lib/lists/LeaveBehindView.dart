import 'package:flutter/material.dart';
 
class LeaveBehindViewLeft extends StatelessWidget {
  LeaveBehindViewLeft({Key key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return new Container(

        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).primaryColor.withAlpha( 75 ),
      
        child: new Row (
          children: <Widget>[

          new Icon(Icons.delete, color: Colors.white,),

          new Expanded(
            child: new Text(''),
          ),

          ],
        ),

      );
  }
 
}

class LeaveBehindViewRight extends StatelessWidget {
  LeaveBehindViewRight({Key key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return new Container(

        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).primaryColor.withAlpha( 75 ),
      
        child: new Row (
          children: <Widget>[

          new Expanded(
            child: new Text(''),
          ),

          new Icon(Icons.delete, color: Colors.white,),
          ],
        ),

      );
  }
 
}