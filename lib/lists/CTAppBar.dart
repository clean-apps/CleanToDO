import 'package:flutter/material.dart';
//import 'package:color/color.dart';

class CTAppBar {

  CTAppBar({ this.filterCategory, this.deleteCategory,
             this.isSearch, this.isMyDay, this.toggleSearch,
             this.searchString, this.doSearch,
             this.themeColor, this.updateColor,
  });

  final String appDefaultTitle = 'To-Do';

  final String filterCategory ;
  final ValueChanged<String> deleteCategory ;

  final bool isSearch ;
  final bool isMyDay ;
  final ValueChanged<bool> toggleSearch ;

  final String searchString ;
  final ValueChanged<String> doSearch ;

  final String themeColor ;
  final ValueChanged<String> updateColor ;

  IconButton colorIcon( Color btnColor, String colorName, context ){
    return new IconButton(
      icon: new CircleAvatar( backgroundColor: btnColor, minRadius: 40.0,),
      iconSize: 75.0,
      onPressed: (() {
        updateColor(colorName);
        Navigator.pop(context);

        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Row(
                children: <Widget>[
                  new Icon( Icons.refresh ),
                  new Padding(padding: new EdgeInsets.only(left: 10.0), child: new Text('Information'),)
                ],
              ),
              content: new Text('please restart the app for new color scheme'),
            ),
        );


      }),
    );
  }

  _appBarActions( int actionId, BuildContext context ) {
    switch (actionId) {

      case 0: deleteCategory(filterCategory);
              break;

      case 1: showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context){

            return new ListView (

                    children: <Widget>[

                      new ListTile(
                        leading: new Icon( Icons.color_lens ),
                        title: new Text( 'Select New Color', style: new TextStyle( fontSize: 20.0 ), ),
                      ),

                      new ListTile(
                        title: new Row(
                          children: <Widget>[
                            colorIcon(Colors.blue, 'blue', context),
                            colorIcon(Colors.indigo, 'indigo', context),
                            colorIcon(Colors.cyan, 'cyan', context),
                            colorIcon(Colors.teal, 'teal', context),
                          ],
                        ),
                      ),

                      new ListTile(
                        title: new Row(
                          children: <Widget>[
                            colorIcon(Colors.brown, 'brown', context),
                            colorIcon(Colors.purple, 'purple', context),
                            colorIcon(Colors.deepPurple, 'deepPurple', context),
                            colorIcon(Colors.amber, 'amber', context),
                          ],
                        ),
                      ),

                      new ListTile(
                        title: new Row(
                          children: <Widget>[
                            colorIcon(Colors.red, 'red', context),
                            colorIcon(Colors.pink, 'pink', context),
                            colorIcon(Colors.grey, 'grey', context),
                            colorIcon(Colors.blueGrey, 'blueGrey', context),
                          ],
                        ),
                      ),

                    ],

                  );

            //return ;

          }
      );
      break;
    }
  }

  AppBar mydayAppBar(){

    return new AppBar(
      title: new Text( 'My Day' ),
      elevation: 0.0,
    );

  }

  AppBar homeAppBar(){

    return new AppBar(
      title: new Text( appDefaultTitle),
      actions: [

        new IconButton(
          icon: new Icon( Icons.search ),
          onPressed: (){
            toggleSearch(true);
          },
        ),

      ],
    );

  }

  AppBar searchAppBar(){

    return new AppBar(

      leading: new IconButton(
        icon: new Icon( Icons.arrow_back ),
        onPressed: (){
          toggleSearch(false);
        },
      ),

      title: new TextField(
        autofocus: true,
        style: new TextStyle(color: Colors.white),
        controller: new TextEditingController(text: searchString),
        decoration: new InputDecoration( hintText: 'Search', hintStyle: new TextStyle( color: Colors.white70 ) ),
        onSubmitted: (value) => doSearch( value ),

      ),

      actions: [

        new IconButton(
          icon: new Icon( Icons.clear ),
          onPressed: (){
            toggleSearch(false);
          },
        ),

      ],
    );

  }

  AppBar filterAppBar(context){

    return new AppBar(
      title: new Text(filterCategory),
      actions: [

        new IconButton(
          icon: new Icon( Icons.search ),
          onPressed: (){
            toggleSearch(true);
          },
        ),

        new PopupMenuButton<int>(

            onSelected: (value) =>  _appBarActions(value, context),
            itemBuilder: (BuildContext context) {

              return <PopupMenuEntry<int>>[

                new PopupMenuItem<int>(
                  value: 1,
                  child: new Text('Change Color'),
                ),

                new PopupMenuItem<int>(
                  value: 0,
                  child: new Text('Delete List'),
                ),

              ];

            },
        )

      ],
    );

  }

  AppBar build(context) {

    if( isMyDay )
      return mydayAppBar();

    if( isSearch )
      return searchAppBar();

    else if( filterCategory == null )
      return  homeAppBar();

    else
      return filterAppBar(context);
  }

}