import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Category.dart';

class _SystemPadding extends StatelessWidget {

  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

class NewCategoryDialog extends StatefulWidget {

  NewCategoryDialog({Key key, this.addCategory }) : super(key: key);

  final ValueChanged<Category> addCategory ;

  @override
  _NewCategoryDialogState createState() => new _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {

  final TextEditingController _new_cat_cont = new TextEditingController();
  
    Widget build(BuildContext context) {
    
      return new _SystemPadding (

        child: new SimpleDialog(

        title: new Text('New List'),
        contentPadding: new EdgeInsets.all(10.0),
        children: <Widget> [

            new Padding(

              padding: new EdgeInsets.only( left: 10.0, right: 10.0 ),
              child : new TextField(
                controller: _new_cat_cont,
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
                            text : _new_cat_cont.text,
                            icon: Icons.list,
                            count: 0,
                          )
                        );
                      });
                    })),

                ],
              ),
            ),

          ],

        )
      );
    
    }
}