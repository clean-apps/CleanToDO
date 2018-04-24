import 'package:flutter/material.dart';

class _SystemPaddingDID extends StatelessWidget {

  final Widget child;

  _SystemPaddingDID({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

class TextInputDialog extends StatelessWidget {

  TextInputDialog({ this.title, this.content, this.updateContent });

  final String title ;
  String content;
  final ValueChanged<String> updateContent;  

  final TextEditingController _update_content = new TextEditingController();

  @override
    Widget build(BuildContext context) {

      _update_content.text = this.content;

      return new _SystemPaddingDID (

        child: new SimpleDialog(

          title: new Text( this.title ),
          contentPadding: new EdgeInsets.all(10.0),

          children: <Widget> [

            new Padding(

              padding: new EdgeInsets.only( left: 10.0, right: 10.0 ),
              child : new TextField(
                controller: _update_content,
                decoration: new InputDecoration(
                  hintText: this.content == null ? 'untitled' : null,
                )
              )
            ),

          new ButtonTheme.bar(
              child: new ButtonBar(
                children: <Widget>[

                  new FlatButton(
                    child: const Text('Cancel'),
                    onPressed: ((){
                      Navigator.pop(context);
                    }),
                  ),

                  new FlatButton(
                    child: const Text('Save'),
                    onPressed: ((){
                      this.updateContent( _update_content.text );
                      Navigator.pop(context);
                    })
                  ),

                ],
              ),
            ),

          ],

        )

      );
    }

}