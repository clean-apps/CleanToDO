import 'package:flutter/material.dart';
import 'package:clean_todo/data/CategoryProvider.dart';

class Category {

  Category ({ this.id, this.text, this.icon, this.count });

  int id;
  String text ;
  IconData icon ;
  int count ;

  Category clone(){
    return new Category( text: text, icon: icon, count: count );
  }

  int get hashCode => text.hashCode;

  Map<String, dynamic>  toMap() {
    Map<String, dynamic> map = {
              CategoryProvider.columnId: id,
              CategoryProvider.columnText: text,
              CategoryProvider.columnCount: count
            } ;

    return map;
  }

  Category.fromMap(Map map) {

            id = map[CategoryProvider.columnId];
            text = map[CategoryProvider.columnText];
            count = map[CategoryProvider.columnCount];
  }
}