import 'package:flutter/material.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/settings/LoginScreen.dart';
import 'package:clean_todo/styles/AppIcons.dart';

class AboutView extends StatelessWidget {

  DataCache cache ;
  SettingsManager settings ;
  AboutView({ this.cache, this.settings });

  @override
  Widget build(BuildContext context) {

    AppIcons icons = new AppIcons();

    return new Scaffold(

      appBar: new AppBar(
        title: new Text( 'About' ),
      ),

      body: new ListView(
        children: <Widget>[

      new Card(
        child: new ListTile(
            leading: new CircleAvatar(
              child: new Text( cache.userData.abbr == null ? '' : cache.userData.abbr, style: new TextStyle( color: Colors.white ), ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: new Text( cache.userData.userName == null ? '' : cache.userData.userName ),
            trailing: new RaisedButton(
                color: Colors.red,
                child: new Text( "logout", style: new TextStyle( color: Colors.white ), ),
                onPressed: ((){
                  cache.userData.userName = null;
                  cache.userData.abbr = null;
                  settings.username = null;
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (context) =>
                          new LoginScreen(
                            cache: cache,
                            settings: settings,
                          ),
                    )
                  );
                }),
            ),
          ),
      ),

      new Card(
        child: new Column(
            children: <Widget>[
              new ListTile(
                leading: icons.reCaluclateCountsIcon(context),
                title: new Text( "Fix Sidebar Counts" ),
                onTap: (){
                  cache.reset_category_counts()
                       .whenComplete(
                          () => showDialog(
                                  context: context,
                                  builder: (_) => new AlertDialog(
                                    content: new Text('sidebar list counts\' re-calculation done'),
                                    actions: <Widget>[
                                      new FlatButton(
                                          onPressed: () => Navigator.pop(_),
                                          child: new Text( "OK" )
                                      )
                                    ],
                                  ),
                                )
                  );
                },
              ),
            ]
        ),
      ),

      new Card(
        child: new Column(
          children: <Widget>[
            new ListTile(
              title: new Text( "Version" ),
              subtitle: new Text( "1.1.20180620" ),
            ),
          ]
        ),
      ),


        ],
      ),

    );
  }
}