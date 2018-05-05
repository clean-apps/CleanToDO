import 'package:flutter/material.dart';

class Category {

  Category ({ this.text, this.icon, this.count });

  final String text ;
  final IconData icon ;
  int count ;

  Category clone(){
    return new Category( text: text, icon: icon, count: count );
  }

  int get hashCode => text.hashCode;
}