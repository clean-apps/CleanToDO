import 'package:flutter/material.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/settings/Themes.dart';
import 'package:clean_todo/lists/TasksPage.dart';
import 'package:clean_todo/beans/UserData.dart';

class LoginScreen extends StatelessWidget {

  DataCache cache;
  SettingsManager settings;

  LoginScreen({this.settings, this.cache});
  bool autoValidate = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>(debugLabel: 'inputForm');

  _handleEmailLogin(context, name, email) {

    final FormState form = _formKey.currentState;
    if (form.validate()) {
      settings.username = name;
      settings.email = email;
      settings.isLoggedIn = true;

      cache.userData = new UserData(name, email);

      runApp(
        new MaterialApp(
          theme: Themes.get(settings.theme),
          home: new TasksPage(
              settings: this.settings, cache: this.cache),
        ),
      );

      /*
      Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (_) => new MaterialApp(
                      theme: Themes.get(settings.theme),
                      home: new TasksPage(
                          settings: this.settings, cache: this.cache),
                    )),
          );
          */
    }

  }

  _handleNoLogin(context) {

    settings.username = null;
    settings.email = null;
    settings.isLoggedIn = true;
    
    cache.userData = new UserData(null, null);

    runApp(
      new MaterialApp(
        theme: Themes.get(settings.theme),
        home: new TasksPage(
            settings: this.settings, cache: this.cache),
      ),
    );

    /*
    Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (_) => new MaterialApp(
            theme: Themes.get(settings.theme),
            home: new TasksPage(
                settings: this.settings, cache: this.cache),
          )),
    );
    */
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController tecEmail = new TextEditingController();
    TextEditingController tecName = new TextEditingController();

    TextStyle brandLight =
      new TextStyle(
          color: Colors.blue,
          fontSize: 38.0,
          fontWeight: FontWeight.w200);

    TextStyle brandBold =
      new TextStyle(
        color: Colors.blue,
        fontSize: 30.0,
        fontWeight: FontWeight.normal);

    TextStyle lightSmall =
      new TextStyle(
        color: Colors.grey,
        decoration: TextDecoration.none,
        fontSize: 20.0);

    return new MaterialApp(
      home: new Builder(builder: (BuildContext bodyContext) {
        return new Scaffold(

            body: new Form(

              key: _formKey,
              child: new Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[

                    new Text( 'Welcome to', style: brandLight ),

                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Image.asset( 'images/logo.png', height: 30.0, ),
                        new Padding(
                          padding: new EdgeInsets.only(left: 10.0),
                          child: new Text( 'Clean To-Do', style: brandBold ),
                        ),
                      ],
                    ),

                    new Padding(
                      padding: new EdgeInsets.only( top: 20.0, left: 50.0, right: 50.0, ),
                      child: new TextFormField(

                        decoration: new InputDecoration(
                          labelText: 'Email',
                        ),

                        controller: tecEmail,
                        autovalidate: autoValidate,
                        keyboardType: TextInputType.emailAddress,

                        validator: (valueEmail) {
                          if (valueEmail.isEmpty) {
                            return 'please enter your email';
                          }
                        },

                      ),
                    ),

                    new Padding(
                        padding: new EdgeInsets.only( top: 20.0, bottom: 75.0, left: 50.0, right: 50.0, ),
                        child: new TextFormField(

                          decoration: new InputDecoration(
                            labelText: 'Name',
                          ),

                          controller: tecName,
                          autovalidate: autoValidate,

                          validator: (valueName) {
                            if (valueName.isEmpty) {
                              return 'please enter your name';
                            }
                          },

                        )
                    ),

                    new RaisedButton(
                      child: new Text( 'Sign Up', style: new TextStyle(fontSize: 20.0, color: Colors.white), ),
                      elevation: 5.0,
                      color: Colors.blue,
                      padding: new EdgeInsets.only( top: 18.0, bottom: 18.0, left: 80.0, right: 80.0),
                      onPressed: () => _handleEmailLogin(
                          bodyContext, tecName.text, tecEmail.text),
                    ),

                    new Padding(
                      padding: new EdgeInsets.all( 20.0 ),
                    ),

                    new FlatButton(
                      child: new Text( 'skip', style: lightSmall, ),
                      padding: new EdgeInsets.only( top: 18.0, bottom: 18.0, left: 80.0, right: 80.0),
                      onPressed: () => _handleNoLogin(bodyContext),
                    )

                  ],
            ),
        ));
      }),
    );
  }
}
