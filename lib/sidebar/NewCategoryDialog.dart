import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Category.dart';

class NewCategoryDialog extends StatefulWidget {

  NewCategoryDialog({Key key, this.addCategory }) : super(key: key);

  final ValueChanged<Category> addCategory ;

  @override
  _NewCategoryDialogState createState() => new _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {

  final TextEditingController _newCatCont = new TextEditingController();
  
    Widget build(BuildContext context) {
    
      return new SimpleDialog(

        title: new Text('New List'),
        contentPadding: new EdgeInsets.all(10.0),
        children: <Widget> [

            new Padding(

              padding: new EdgeInsets.only( left: 10.0, right: 10.0 ),
              child : new TextField(
                controller: _newCatCont,
                decoration: new InputDecoration(
                  hintText: 'untitled'
                ),
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

                      this.setState((){
                        widget.addCategory(
                          new Category (
                            text : _newCatCont.text,
                            icon: Icons.list,
                            count: 0,
                          )
                        );
                      });

                      Navigator.pop(context);

                    })),

                ],
              ),
            ),

          ],

        );
    
    }
}