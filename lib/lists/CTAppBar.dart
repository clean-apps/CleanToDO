import 'package:flutter/material.dart';

class CTAppBar {

  CTAppBar({ this.filterCategory, this.deleteCategory,
             this.isSearch, this.isMyDay, this.toggleSearch,
             this.searchString, this.doSearch,
  });

  final String appDefaultTitle = 'To-Do';

  final String filterCategory ;
  final ValueChanged<String> deleteCategory ;

  final bool isSearch ;
  final bool isMyDay ;
  final ValueChanged<bool> toggleSearch ;

  final String searchString ;
  final ValueChanged<String> doSearch ;

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

  AppBar filterAppBar(){

    return new AppBar(
      title: new Text(filterCategory),
      actions: [

        new IconButton(
          icon: new Icon( Icons.search ),
          onPressed: (){
            toggleSearch(true);
          },
        ),

        new PopupMenuButton<String>(

            onSelected: (value) =>  deleteCategory(value),
            itemBuilder: (BuildContext context) {

              return <PopupMenuEntry<String>>[

                new PopupMenuItem<String>(
                  value: filterCategory,
                  child: new Text('Delete Category'),
                ),

              ];

            },
        )

      ],
    );

  }

  AppBar build() {

    if( isMyDay )
      return mydayAppBar();

    if( isSearch )
      return searchAppBar();

    else if( filterCategory == null )
      return  homeAppBar();

    else
      return filterAppBar();
  }

}