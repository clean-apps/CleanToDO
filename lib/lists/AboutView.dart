import 'package:flutter/material.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/settings/LoginScreen.dart';

class AboutView extends StatelessWidget {

  DataCache cache ;
  SettingsManager settings ;
  AboutView({ this.cache, this.settings });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: new AppBar(
        title: new Text( 'About' ),
      ),

      body: new ListView(
        children: <Widget>[

      new Card(
        child: new ListTile(
            leading: new CircleAvatar(
              child: new Text( cache.userData.abbr, style: new TextStyle( color: Colors.white ), ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: new Text( cache.userData.userName ),
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
                  title: new Text( "Version" ),
                  subtitle: new Text( "1.0.20180610" ),
                ),
              ]
            ),
          ),


        ],
      ),

    );
  }
}