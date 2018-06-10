import 'package:flutter/material.dart';
import 'package:clean_todo/styles/AppIcons.dart';

class TitleDetailTile extends StatelessWidget {

  TitleDetailTile({ this.completed, this.update_completed, this.title, this.update_title });

  final bool completed ;
  final ValueChanged<bool> update_completed ;

  final String title ;
  final ValueChanged<String> update_title ;

  final AppIcons icons = new AppIcons();

  @override
  Widget build(BuildContext context) {

    return new ListTile(

      leading: new IconButton(
        icon:  this.completed ? icons.taskCompletedIcon(context) : icons.taskPendingIcon(context),
        onPressed: (){
          this.completed ? this.update_completed( false ): this.update_completed( true );
        },
      ),

      title: new TextField(

        autofocus: true,
        controller: new TextEditingController( text: this.title ),

        onSubmitted: (value) => update_title( value ),
        //onChanged: (value) => update_title( value ),

        style: new TextStyle( fontSize: 24.0, color: Theme.of(context).accentColor ),

        decoration: new InputDecoration(

          border: InputBorder.none,

          hintText: 'Enter Title',
          hintStyle: new TextStyle( fontSize: 24.0, color: Colors.grey ),

          labelText: 'Title',
          labelStyle: new TextStyle( fontSize: 18.0, color: Colors.grey ),

        ),

      ),

      trailing: new IconButton(
        icon:  new Icon( Icons.clear, color: this.title == null ? Colors.white : Theme.of(context).iconTheme.color, ),
        onPressed: () => update_title( null ),
      ),

    );
  }

}