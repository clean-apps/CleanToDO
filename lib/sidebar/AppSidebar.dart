import 'package:flutter/material.dart';
import 'package:clean_todo/sidebar/NewCategoryDialog.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/UserData.dart';
import 'package:clean_todo/beans/CategoryData.dart';

class AppSidebar extends StatefulWidget {

  AppSidebar({  Key key, this.categories, this.addCategory, this.filter, this.userData })
   : super(key: key);

  final UserData userData ;
  final CategoryData categories ;

  final ValueChanged<Category> addCategory ;
  final ValueChanged<String> filter ;

  @override
  _AppSidebarState createState() => new _AppSidebarState();
  
}

class _AppSidebarState extends State<AppSidebar> {

  ListTile getAsSystemListTile( Category categoryData ){

    return new ListTile(
        leading: new Icon( categoryData.icon == null ? Icons.list : categoryData.icon, color: Theme.of(context).primaryColor,  ),
        title: new SidebarText( textContent : categoryData.text ),
        onTap: () {
          widget.filter( categoryData.text );
        }
    );

  }

  ListTile getAsListTile( Category categoryData ){

    return new ListTile(
      leading: new Icon( categoryData.icon == null ? Icons.list : categoryData.icon, color: Theme.of(context).primaryColor,  ),
      title: new SidebarText( textContent : categoryData.text ),
      trailing: new Text( categoryData.count == null ? "0" : categoryData.count.toString() ),
      onTap: () {
          widget.filter( categoryData.text );
      }
    );

  }

  @override
  Widget build(BuildContext context) {

    List<Widget> systemCategoryWdigets = [];
    widget.categories.system.forEach( (cb) {
      systemCategoryWdigets.add(  getAsSystemListTile(cb) );
    });

    List<Widget> userCategoryWdigets = [];
    widget.categories.user.forEach( (cb) {
      userCategoryWdigets.add(  getAsListTile(cb) );
    });

    return new Drawer(

        child: new ListView(

                padding: new EdgeInsets.only(top: 30.0),
                children: <Widget>[

                  new ListTile(
                      leading: new CircleAvatar(
                                      child: new Text( widget.userData.abbr, style: new TextStyle( color: Colors.white ), ),
                                      backgroundColor: Theme.of(context).primaryColor,
                                    ),
                      title: new SidebarText( textContent : widget.userData.userName ) ,
                  ),

                  new Divider(),

                  new Column(
                    children: systemCategoryWdigets,
                  ),
                  
                  new Divider(),

                  new ListTile(
                    leading: new Icon( Icons.add, color: Theme.of(context).primaryColor, ),
                    title: new SidebarText( textContent : 'New List' ),
                    onTap: () {   showDialog(
                                    context: context,
                                    child: new NewCategoryDialog( addCategory: widget.addCategory ),
                                  );
                              }
                  ),

                  new Column(
                    children: userCategoryWdigets,
                  ),
                  
                ],
        ),

    );
  }
}

class SidebarText extends StatelessWidget {

  SidebarText({this.textContent});

  final String textContent;

  @override
  Widget build(BuildContext context) {
    return new Text( 
      this.textContent,
      style: new TextStyle( fontSize: 18.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w300 ),
    );
  }

}