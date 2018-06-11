import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/CategoryGroup.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/styles/AppIcons.dart';

class NewCategoryDialog extends StatefulWidget {

  NewCategoryDialog({Key key, this.categoryData, this.addCategory, this.addCategoryGroup }) : super(key: key);

  final CategoryData categoryData;
  final ValueChanged<Category> addCategory ;
  final ValueChanged<CategoryGroup> addCategoryGroup ;

  int selectedGroupId ;
  bool newGroup ;

  @override
  _NewCategoryDialogState createState() => new _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {

  List<DropdownMenuItem<String>> getCatagoryGroups(){

      var icons = new AppIcons();
      List<DropdownMenuItem<String>> listCategoryGroups = [];

      listCategoryGroups.add(

          new DropdownMenuItem<String>(
            value: "-1",
            child: new SizedBox(
              width: 330.0,
              child: new ListTile(
                leading:  new Padding(
                    padding: new EdgeInsets.only( bottom: 10.0 ),
                    child: icons.groupOpenIcon(context),
                ),
                title:  new Padding(
                    padding: new EdgeInsets.only( bottom: 10.0 ),
                    child: new Text( 'Select List Group', style: new TextStyle( fontSize: 20.0 ) ),
                ),
              ),
            ),
          )

      );

      listCategoryGroups.addAll(

          widget.categoryData.userGroups.map( (categoryData){

            return new DropdownMenuItem<String>(
              value: categoryData.id.toString(),
              child: new SizedBox(
                width: 330.0,
                child: new ListTile(
                  leading:  new Padding(
                      padding: new EdgeInsets.only( bottom: 10.0 ),
                      child: icons.groupIcon(context),
                  ),
                  title:  new Padding(
                    padding: new EdgeInsets.only( bottom: 10.0 ),
                    child: new Text( categoryData.text, style: new TextStyle( fontSize: 20.0 ) ),
                  ),
                ),
              ),
            );

          })

      );

      listCategoryGroups.add(

          new DropdownMenuItem<String>(
            value: "-2",
            child: new SizedBox(
              width: 330.0,
              child: new ListTile(
                leading:  new Padding(
                  padding: new EdgeInsets.only( bottom: 10.0 ),
                  child: icons.newGroupIcon(context),
                ),
                title:  new Padding(
                  padding: new EdgeInsets.only( bottom: 10.0 ),
                  child: new Text( 'New List Group', style: new TextStyle( fontSize: 20.0 ) ),
                ),
              ),
            ),
          )

      );

      //print( "listCategoryGroups :: " + listCategoryGroups.toString() );
      return listCategoryGroups;
  }

  final TextEditingController _newCatCont = new TextEditingController();
  final TextEditingController _newCaCGrpCont = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

    Widget build(BuildContext context) {

      widget.selectedGroupId = widget.categoryData.newCategoryGroup.id;
      widget.newGroup = widget.categoryData.newGroup;
      //print( "new value to dpd ::" + widget.selectedGroupId.toString() );

      return new Scaffold(

          appBar: new AppBar(

            leading: new IconButton(
              icon: new Icon( Icons.clear, color: Theme.of(context).iconTheme.color, ),
              onPressed: () => Navigator.of(context).pop(),
            ),

            title: new Text( 'New List', style: new TextStyle( color: Theme.of(context).accentColor ), ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,

            actions: <Widget>[

              new FlatButton(
                  onPressed: () {

                    this.setState((){

                      final FormState form = _formKey.currentState;
                      if( form.validate() ) {

                        if (widget.selectedGroupId > 0) {

                          widget.addCategory(
                              new Category (
                                groupId: widget.selectedGroupId,
                                text: _newCatCont.text,
                                icon: Icons.list,
                                count: 0,
                              )
                          );

                          Navigator.of(context).pop();

                        } else if (widget.selectedGroupId == -2) {

                          int newGroupId = widget.categoryData.userGroups.last.id + 1;
                          widget.addCategoryGroup(
                              new CategoryGroup(
                                text: _newCaCGrpCont.text,
                                id: newGroupId,
                              )
                          );

                          widget.addCategory(
                              new Category (
                                groupId: newGroupId,
                                text: _newCatCont.text,
                                icon: Icons.list,
                                count: 0,
                              )
                          );

                          Navigator.of(context).pop();

                        } else {

                          showDialog(
                              context: context,
                              builder: ((context){
                                return new AlertDialog(
                                  title: new Text( 'please select a list group' ),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: new Text( 'OK' )
                                    )
                                  ],
                                );
                              }),
                          );

                        }

                      }

                    });

                  },

                  child: new Text('SAVE', style: new TextStyle( color: Theme.of(context).accentColor) )

              ),

            ],

          ),

          body: new Form(
                  key: _formKey,
                  child: new Padding(

                    padding: new EdgeInsets.all( 20.0 ),
                    child:  new ListView(
                      children: <Widget>[

                        new TextFormField(

                          autofocus: true,
                          controller: _newCatCont,
                          style: new TextStyle( fontSize: 20.0, color: Theme.of(context).accentColor ),
                          //maxLines: 10,
                          textAlign: TextAlign.start,

                          decoration: new InputDecoration(
                            hintText: 'untitled',
                            hintStyle: new TextStyle( fontSize: 20.0, color: Colors.grey ),
                            labelText: 'List Name',
                            //border: InputBorder.none,
                          ),

                          validator: (valueListName){
                            if( valueListName.isEmpty ){
                              return 'please enter list name';
                            }
                          },

                        ),

                        new Padding(
                            padding: new EdgeInsets.only( top: 40.0 ),
                            child: new Text('List Group', textDirection: TextDirection.ltr,
                                            style: new TextStyle( color: Theme.of(context).accentColor ),
                            ),
                        ),

                        new DropdownButton<String>(

                          value: widget.selectedGroupId.toString(),
                          iconSize: 0.0,
                          items: getCatagoryGroups(),
                          onChanged: ((_){
                              this.setState((){

                                widget.selectedGroupId = int.parse(_);
                                widget.categoryData.newCategoryGroup.id = int.parse(_);

                                if( _ == "-1" ){

                                  widget.newGroup = false;
                                  widget.categoryData.newGroup = false;

                                } else  if ( _ == "-2" ){

                                  widget.newGroup = true;
                                  widget.categoryData.newGroup = true;

                                } else {

                                  widget.newGroup = false;
                                  widget.categoryData.newGroup = false;

                                }

                              });
                          }),

                        ),

                        new Padding(
                          padding: new EdgeInsets.only( top: 20.0 ),
                        ),

                        widget.newGroup ? new TextFormField(

                          autofocus: true,
                          controller: _newCaCGrpCont,
                          style: new TextStyle( fontSize: 20.0, color: Theme.of(context).accentColor ),
                          //maxLines: 10,
                          textAlign: TextAlign.start,

                          decoration: new InputDecoration(
                            hintText: 'untitled',
                            hintStyle: new TextStyle( fontSize: 20.0, color: Colors.grey ),
                            labelText: 'List Group Name',
                            //border: InputBorder.none,
                          ),

                          validator: (valueGroupName){
                            if( widget.selectedGroupId == -2 && valueGroupName.isEmpty ){
                              return 'please enter list group name';
                            }
                          },

                        ) : new Text(' '),

                      ],
                    )
                  ),

          ),

        );
    
    }
}