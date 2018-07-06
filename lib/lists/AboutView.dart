import 'package:flutter/material.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/settings/LoginScreen.dart';
import 'package:clean_todo/styles/AppIcons.dart';

import 'package:clean_todo/settings/Themes.dart';
import 'package:clean_todo/main.dart';

class AboutView extends StatefulWidget {

  String appVersion = "1.4.201806230";

  DataCache cache;

  SettingsManager settings;

  AboutView({ this.cache, this.settings,});

  @override
  _AboutViewState createState() => new _AboutViewState();

}

class _AboutViewState  extends State<AboutView> {

  _doFixCounts(){
    widget.cache.reset_category_counts()
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
  }

  _updateShowCompletedTasks(value){
    this.setState( () {
      widget.cache.showCompletedTasks = value;
      widget.settings.showCompleted = value;
    });
  }

  _showSortListView(){

    String sortString = widget.cache.sortTasks;
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context){

          return new ListView (

            children: <Widget>[

              new ListTile(
                title: new Text( 'Sort Tasks', style: new TextStyle( fontSize: 20.0 ), ),
              ),

              new ListTile(
                leading: new Icon( Icons.sort_by_alpha ),
                title: new Text( 'Albhabetically' ),
                onTap: ((){
                  this.updateSortTasks('SORT_BY_ALPHA');
                  Navigator.pop(context);
                }),
                trailing: sortString == 'SORT_BY_ALPHA' ? new Icon( Icons.check ) : null,
              ),

              new ListTile(
                leading: new Icon( Icons.date_range ),
                title: new Text( 'Due Date' ),
                onTap: ((){
                  this.updateSortTasks('SORT_BY_DUE');
                  Navigator.pop(context);
                }),
                trailing: sortString == 'SORT_BY_DUE' ? new Icon( Icons.check ) : null,
              ),

              new ListTile(
                leading: new Icon( Icons.add_circle_outline ),
                title: new Text( 'Creation Date' ),
                onTap: ((){
                  this.updateSortTasks('SORT_BY_CREA');
                  Navigator.pop(context);
                }),
                trailing: sortString == 'SORT_BY_CREA' ? new Icon( Icons.check ) : null,
              ),

              new ListTile(
                leading: new Icon( Icons.check ),
                title: new Text( 'Completed' ),
                onTap: ((){
                  this.updateSortTasks('SORT_BY_COMPLETED');
                  Navigator.pop(context);
                }),
                trailing: sortString == 'SORT_BY_COMPLETED' ? new Icon( Icons.check ) : null,
              ),

            ],

          );

          //return ;

        }
    );

  }

  updateSortTasks(value){
    this.setState((){
      widget.cache.sortTasks = value;
      widget.settings.sortString = value;
    });
  }

  _updateColor(value) {
    this.setState(() {
      widget.settings.theme = value;
    });

    runApp(
      new CleanToDoApp(
        cache: widget.cache,
        settings: widget.settings,
      ),
    );
  }

  IconButton colorIcon( Color btnColor, AppColors color, context ){

    String themeColor = widget.settings.theme == null ? 'blue' : widget.settings.theme;

    return new IconButton(
      icon: new CircleAvatar(
        backgroundColor: btnColor,
        minRadius: 40.0,
        child: color.index.toString() == themeColor ? new Icon( Icons.check, size: 30.0,) : null,
      ),

      iconSize: 75.0,
      onPressed: () => _updateColor(color.index.toString())
    );
  }

  _showColorPopup(){

    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context){

          return new ListView (

            children: <Widget>[

              new ListTile(
                title: new Text( 'Select New Color', style: new TextStyle( fontSize: 20.0 ), ),
              ),

              new ListTile(
                title: new Row(
                  children: <Widget>[
                    colorIcon(Colors.blue, AppColors.BLUE, context),
                    colorIcon(Colors.indigo, AppColors.INDIGO, context),
                    colorIcon(Colors.cyan, AppColors.CYAN, context),
                    colorIcon(Colors.teal, AppColors.TEAL, context),
                  ],
                ),
              ),

              new ListTile(
                title: new Row(
                  children: <Widget>[
                    colorIcon(Colors.brown, AppColors.BROWN, context),
                    colorIcon(Colors.purple, AppColors.PURPLE, context),
                    colorIcon(Colors.deepPurple, AppColors.DEEP_PURPLE, context),
                    colorIcon(Colors.amber, AppColors.AMBER, context),
                  ],
                ),
              ),

              new ListTile(
                title: new Row(
                  children: <Widget>[
                    colorIcon(Colors.red, AppColors.RED, context),
                    colorIcon(Colors.pink, AppColors.PINK, context),
                    colorIcon(Colors.blueGrey, AppColors.BLUE_GREY, context),
                    colorIcon(Colors.black, AppColors.BLACK, context),
                  ],
                ),
              ),

            ],

          );

          //return ;

        }
    );
  }


  @override
  Widget build(BuildContext context) {

    AppIcons icons = new AppIcons();
    DataCache cacheN = widget.cache;
    SettingsManager settingsN = widget.settings;

    bool isShowCompletedTasks = cacheN.showCompletedTasks ;
    bool isEnableNotificationSounds = settingsN.notification_sounds;
    bool isEnableNotificationVibrations = settingsN.notification_vibrations;

    return new Scaffold(

      appBar: new AppBar(
        title: new Text( 'About' ),
      ),

      body: new ListView(
        children: <Widget>[

          new Card(
            child: new ListTile(

                leading: cacheN.userData.abbr == null ?
                          new Icon( Icons.account_circle ):
                          new CircleAvatar(
                            child: new Text( cacheN.userData.abbr, style: new TextStyle( color: Colors.white ), ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),

                title: new Text( cacheN.userData.userName == null ? 'User Data' : cacheN.userData.userName ),
                subtitle: cacheN.userData.email == null ? null : new Text( cacheN.userData.email ),

                trailing: new RaisedButton(
                    color: Colors.red,
                    child: new Text( "clear", style: new TextStyle( color: Colors.white ), ),
                    onPressed: ((){

                      cacheN.clean_all().whenComplete( ((){

                        cacheN.userData.userName = null;
                        cacheN.userData.abbr = null;
                        settingsN.username = null;

                        runApp(
                          new LoginScreen(
                            cache: cacheN,
                            settings: settingsN,
                          ),
                        );

                      }) );

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
                    onTap: () => _doFixCounts(),
                  ),

                  new ListTile(
                    leading: new Icon( isShowCompletedTasks ? Icons.check_box : Icons.check_box_outline_blank ),
                    title: new Text( isShowCompletedTasks ? 'Hide Completed Tasks' : 'Show Completed Tasks' ),
                    onTap: () => _updateShowCompletedTasks( !isShowCompletedTasks ),
                  ),

                  new ListTile(
                    leading: new Icon( Icons.sort ),
                    title: new Text( "Sort" ),
                    onTap: () => _showSortListView(),
                  ),

                  new ListTile(
                    leading: new Icon( Icons.color_lens ),
                    title: new Text( "Color Scheme" ),
                    onTap: () => _showColorPopup(),
                  ),

                ]
            ),
          ),

          /*
          new Card(
            child: new Column(
                children: <Widget>[

                  new ListTile(
                    leading: new Icon( Icons.notifications_active ),
                    title: new Text( isEnableNotificationSounds ? "Disable Notification Sounds"  : "Enable Notification Sounds" ),
                    onTap: () => this.setState( () => settingsN.notification_sounds = !isEnableNotificationSounds ),
                  ),

                  new ListTile(
                    leading: new Icon( Icons.notifications_paused ),
                    title: new Text( isEnableNotificationVibrations ? "Disable Notification Vibrations" : "Enable Notification Vibrations" ),
                    onTap: () => this.setState( () => settingsN.notification_vibrations = !isEnableNotificationVibrations ),
                  ),

                ],
            ),
          ),
          */

          new Card(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text( "Application Version" ),
                  subtitle: new Text( settingsN.projectVersion ),
                ),
              ]
            ),
          ),

        ],
      ),

    );
  }
}