import 'package:flutter/material.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/settings/Themes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clean_todo/lists/TasksPage.dart';
import 'package:clean_todo/beans/UserData.dart';

class LoginScreen extends StatelessWidget {

  DataCache cache;
  SettingsManager settings;
  GoogleSignIn _googleSignIn = new GoogleSignIn();

  LoginScreen({this.settings, this.cache});

  _handleLogin(context) {

      _googleSignIn
          .signIn()
          .then((GoogleSignInAccount value){

          print( "google user photoUrl -" + value.photoUrl ) ;
          settings.username = value.displayName;
          cache.userData = new UserData(value.displayName);

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
        home: new Builder(builder: (BuildContext bodyContext) {

          return new Container(

              color: Colors.white,
              child: new Column(

                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[

                  new Image.asset('images/logo.png'),

                  //new Text( 'Login to Clean To-Do', style: new TextStyle( fontSize: 20.0, color: Colors.blue ) ),

                  new Padding(
                    padding: new EdgeInsets.only( top: 50.0 ),
                    child: new RaisedButton(
                      child: new Text('Sign in', style: new TextStyle( fontSize: 20.0, color: Colors.white ),),
                      elevation: 5.0,
                      color: Colors.blue,
                      padding: new EdgeInsets.only( top: 10.0, bottom: 10.0, left: 40.0, right: 40.0 ),
                      onPressed: () => _handleLogin(bodyContext),
                    ),
                  )

                ],
              ),

         );

        }),
      );
  }
}
