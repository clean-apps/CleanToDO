import 'package:flutter/material.dart';

class DropdownTileSF extends StatefulWidget{

  DropdownTileSF({ this.text, this.hint, this.icon, this.updateContent, this.options });

  String text ;
  final String hint ;
  final IconData icon ;
  final ValueChanged<String> updateContent ;
  final List<DropdownMenuItem<String>> options ;

  @override
  _DropdownTileState createState() => new _DropdownTileState();
}

class _DropdownTileState extends State<DropdownTileSF> {

  @override
  Widget build(BuildContext context) {

      return new ListTile(

          key: widget.key,
          dense: false,
          leading: new Icon( widget.icon, color: Theme.of(context).iconTheme.color, size: 28.0 ,),

          title : new DropdownButtonHideUnderline(
            child: new DropdownButton<String>(
              value: widget.text,
              hint: new Text(widget.hint),
              iconSize: 0.0,
              items: widget.options,

              style: new TextStyle( color: Theme.of(context).accentColor ),
              onChanged: (String value){
                this.setState( ((){
                  widget.text = value;
                  widget.updateContent( value );
                }) );

              },
              
            ),
          ),

          trailing: widget.text == null ? null :
                  new IconButton(
                    icon : new Icon( Icons.clear, color: Theme.of(context).iconTheme.color, ),
                    onPressed: (){
                      this.setState( ((){
                        widget.text = null;
                        widget.updateContent( null );
                      }) );
                    },
                  ),
          
        );
    }


}