import 'package:flutter/material.dart';

class CTExpansionPanel {

  CTExpansionPanel({ this.label, this.subtitle, this.body });

  String label ;
  String subtitle ;
  Widget body ;

  ListTile build(BuildContext context){

    TextStyle headerStyle = new TextStyle( color: Theme.of(context).primaryColor, fontSize: 24.0 );

    return new ListTile(

          title: new Card(

              child: new Column(

                children: <Widget>[

                  new ListTile(
                    title: new Text( label, style: headerStyle, ),
                    subtitle: new Text( subtitle ),
                  ),
                  body,

                ],

              )

          ),

    );

  }

}