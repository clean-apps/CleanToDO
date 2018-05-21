import 'package:flutter/material.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/settings/Themes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clean_todo/lists/TasksPage.dart';
import 'package:clean_todo/beans/UserData.dart';

class LoadingScreen extends StatelessWidget {

  DataCache cache;
  SettingsManager settings;
  GoogleSignIn _googleSignIn = new GoogleSignIn();

  LoadingScreen({this.settings, this.cache});

  _handleLogin(context) {

      _googleSignIn
          .signIn()
          .then((GoogleSignInAccount value){

          print( "google user1 -" + value.displayName ) ;
          settings.username = value.displayName;
          cache.userData = new UserData(userName: value.displayName, abbr: 'SS');

          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (_) => new TasksPage( cache: cache, settings: settings, ),
            ),
          );

      });

      /*
      FirebaseAuth
          .instance
          .signInAnonymously()
          .then((user) {

            print( "google user2 -" + user.displayName ) ;
            settings.username = user.displayName;
            cache.userData = new UserData(userName: user.displayName, abbr: 'SS');


      });
      */
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new Scaffold(
        body: new Builder(builder: (BuildContext bodyContext) {
          return new Center(

            child: new RaisedButton(

              child: new Text('Sign-In'),
              onPressed: _handleLogin(bodyContext),

            ),
          );

        }),
      ),
    );
  }
}
