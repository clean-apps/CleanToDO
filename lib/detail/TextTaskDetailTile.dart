import 'package:flutter/material.dart';
import 'package:clean_todo/detail/TextInputDialog.dart';

class TextTaskDetailTile extends StatelessWidget{
  
  TextTaskDetailTile({ this.text, this.hint, this.icon, this.updateContent });

  final String text ;
  final String hint ;
  final IconData icon ;
  final ValueChanged<String> updateContent ;

  @override
  Widget build(BuildContext context) {
      return new ListTile(

          leading: new Icon( icon, color: Theme.of(context).primaryColor, size: 28.0 ,),

          title: this.text == null ? 
                  new Text( this.hint, style: new TextStyle( color: Colors.grey ), ) :
                  new Text( this.text, style: new TextStyle( color: Theme.of(context).primaryColor ), ),

          trailing: this.text == null ? null : 
                  new IconButton(
                    icon : new Icon( Icons.clear, color: Theme.of(context).primaryColor, ),
                    onPressed: (){
                      this.updateContent( null );
                    },
                  ),

          onTap: (){
            showDialog(
              context: context,
              child: new TextInputDialog(
                title: this.hint,
                content: this.text,
                updateContent: (content){
                  this.updateContent( content );
                },
              ),
            );
          },
          
        );
    }


}