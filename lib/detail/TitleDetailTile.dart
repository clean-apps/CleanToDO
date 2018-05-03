import 'package:flutter/material.dart';
import 'package:clean_todo/detail/TextInputDialog.dart';

class TitleDetailTile extends StatelessWidget {

  TitleDetailTile({ this.completed, this.update_completed, this.title, this.update_title });

  final bool completed ;
  final ValueChanged<bool> update_completed ;

  final String title ;
  final ValueChanged<String> update_title ;

  Widget getStatusIcon( bool completed, context ){

    return completed ?
    new CircleAvatar( child: new Icon( Icons.check, color: Colors.white, size: 14.0, ),
      backgroundColor: Theme.of(context).primaryColor,
      radius: 12.0, ) :
    new Icon( Icons.radio_button_unchecked, size: 28.0, color: Theme.of(context).primaryColor, );

  }

  @override
  Widget build(BuildContext context) {

    return new ListTile(

      leading: new IconButton(
        icon:  getStatusIcon( this.completed, context ),
        onPressed: (){
          this.completed ? this.update_completed( false ): this.update_completed( true );
        },
      ),

      title: new Padding(

        padding: new EdgeInsets.only( top : 20.0, bottom: 20.0 ),
        child: new Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            new Text( 'Title', style: new TextStyle( fontSize: 12.0, color: Colors.grey ), ),
            this.title == null ?
              new Text( 'untitled', style: new TextStyle( fontSize: 24.0, color: Colors.grey ), ) :
              new Text( this.title, style: new TextStyle( fontSize: 24.0, ) ),

          ],

        ) ,
      ),

      onTap: (){

        showDialog(
            context: context,
            child: new TextInputDialog(
            title: 'Title',
            content: this.title,
            updateContent: update_title,
          ),
        );

      },
    );
  }

}