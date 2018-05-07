import 'package:flutter/material.dart';

class NoteDetailDialog extends StatelessWidget {

  NoteDetailDialog({ this.title, this.note, this.updateNote });

  final String title ;
  final String note ;
  final ValueChanged<String> updateNote ;

  TextEditingController noteController ;

  @override
  Widget build(BuildContext context) {

    noteController = new TextEditingController( text: note );

    return new Scaffold(

      backgroundColor: Colors.white,
      appBar: new AppBar(

        leading: new IconButton(
              icon: new Icon( Icons.clear, color: Theme.of(context).primaryColor, ),
              onPressed: () => Navigator.of(context).pop(),
        ),

        title: new Text( title == null ? 'Add a note' : title, style: new TextStyle( color: Theme.of(context).primaryColor ), ),
        backgroundColor: Colors.white,
        elevation: 0.0,

        actions: <Widget>[

          new FlatButton(
              onPressed: () {
                updateNote(noteController.text);
                Navigator.of(context).pop();
              },

              child: new Text('SAVE', style: new TextStyle( color: Theme.of(context).primaryColor) )

          ),

        ],

      ),

      body: new Padding(

          padding: new EdgeInsets.all( 20.0 ),
          child: new TextField(

            autofocus: true,
            controller: noteController,
            style: new TextStyle( fontSize: 20.0, color: Colors.black ),
            maxLines: 10,
            textAlign: TextAlign.start,

            decoration: new InputDecoration(
              hintText: 'Add a note',
              hintStyle: new TextStyle( fontSize: 20.0, color: Colors.grey ),
              border: InputBorder.none,
            ),
    
          ),
      ),

    );
  }

}