import 'package:flutter/material.dart';

class DropdownTile extends StatelessWidget{
  
  DropdownTile({ this.text, this.hint, this.icon, this.updateContent, this.options });

  final String text ;
  final String hint ;
  final IconData icon ;
  final ValueChanged<String> updateContent ;
  final List<DropdownMenuItem<String>> options ;

  @override
  Widget build(BuildContext context) {

      return new ListTile(

          leading: new Icon( icon, color: Theme.of(context).primaryColor, size: 28.0 ,),

          title : new DropdownButtonHideUnderline(
            child: new DropdownButton<String>(
              value: this.text,
              hint: new Text(this.hint),
              iconSize: 0.0,
              items: options,

              style: new TextStyle( color: Theme.of(context).primaryColor ),
              onChanged: (String value){
                this.updateContent( value );
              },
              
            ),
          ),

          trailing: this.text == null ? null : 
                  new IconButton(
                    icon : new Icon( Icons.clear, color: Theme.of(context).primaryColor, ),
                    onPressed: (){
                      this.updateContent( null );
                    },
                  ),
          
        );
    }


}