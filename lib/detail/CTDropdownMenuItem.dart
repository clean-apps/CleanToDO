import 'package:flutter/material.dart';

class CTDropdownMenuItem {

  CTDropdownMenuItem({ this.value });

  final String value;

  DropdownMenuItem build(BuildContext context) {
    return new DropdownMenuItem<String>(
      value: this.value,
      child: new Text( this.value ),
    );
  }

}