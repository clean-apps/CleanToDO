import 'package:flutter/material.dart';

class AppIcons {

  Color _iconColor( context ){
    return Theme.of(context).iconTheme.color;
  }

  newGroupIcon( context ) =>
      new Icon( Icons.create_new_folder, color: _iconColor(context), );

  groupIcon( context ) =>
      new Icon( Icons.folder, color: _iconColor(context), );

  groupOpenIcon( context ) =>
    new Icon( Icons.folder_open, color: _iconColor(context), );

  groupArrowIcon( context ) =>
      new Icon( Icons.keyboard_arrow_down, color: _iconColor(context) );

  groupOpenArrowIcon( context ) =>
      new Icon( Icons.keyboard_arrow_right, color: _iconColor(context), );




  newListIcon( context ) =>
      new Icon( Icons.add, color: _iconColor(context), );

  systemIcon( IconData icon, context ) =>
      new Icon( icon, color: _iconColor(context), );

  listIcon( context ) =>
      new Icon( Icons.list, color: _iconColor(context), );




  taskCompletedIcon( selected, context ) =>
      new CircleAvatar(
        child: new Icon( Icons.check, color: selected ? Theme.of(context).highlightColor : Theme.of(context).scaffoldBackgroundColor, size: 14.0, ),
        backgroundColor: _iconColor(context),
        radius: 12.0,
      );

  taskPendingIcon( selected, context ) =>
      new Icon( Icons.radio_button_unchecked, size: 28.0, color: selected ? Theme.of(context).highlightColor : _iconColor(context), );




  var listIconSize = 14.0;

  listIconDue( selected, context, isDue ) =>
      new Icon( Icons.calendar_today,
                color: selected ? Theme.of(context).highlightColor :
                        (  isDue ? Theme.of(context).errorColor : _iconColor(context) ), size: listIconSize, );

  listIconReminder( selected, context ) =>
      new Icon( Icons.alarm_on, color: selected ? Theme.of(context).highlightColor : _iconColor(context), size: listIconSize,  );

  listIconNotes( selected, context ) =>
      new Icon( Icons.chat_bubble_outline, color: selected ? Theme.of(context).highlightColor : _iconColor(context), size: listIconSize,  );

  listIconRepeat( selected, context ) =>
      new Icon( Icons.repeat, color: selected ? Theme.of(context).highlightColor : _iconColor(context), size: listIconSize,  );


  newTaskModal( context ) =>
      new Icon( Icons.radio_button_unchecked, size: 28.0, color: _iconColor(context), );

  newTaskModalArrow( context ) =>
      new CircleAvatar( child: new Icon( Icons.keyboard_arrow_right, color: Colors.white,), backgroundColor: Theme.of(context).primaryColorLight, );

  newTaskFabIcon(context) =>
      new Icon(Icons.add);

  reCaluclateCountsIcon(context) =>
      new Icon( Icons.format_list_numbered );

  noTasksIcon(context) =>
      new Icon( Icons.list, size: 150.0, color: _iconColor(context).withAlpha( 70 ),  );
}