import 'package:flutter/material.dart';

class IconText extends StatelessWidget {

  IconData icon;
  String label;
  IconText({ this.icon, this.label });

  @override
  Widget build(BuildContext context) {

    return new Row(
      children: <Widget>[
        new Icon( icon, color: Theme.of(context).iconTheme.color ),
        new Padding(
          padding: new EdgeInsets.only(left: 10.0,),
          child: new Text(label, style: new TextStyle( color: Theme.of(context).accentColor ),),
        ),

      ],
    );

  }

}