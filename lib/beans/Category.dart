import 'package:flutter/material.dart';
import 'package:clean_todo/data/CategoryProvider.dart';

class Category {

  Category ({ this.id, this.groupId, this.text, this.icon, this.count });

  int id;
  int groupId;
  String text ;
  IconData icon ;
  int count ;

  Category clone(){
    return new Category( id: id, groupId: this.groupId, text: text, icon: icon, count: count );
  }

  int get hashCode => ( groupId.toString() + "_" + text ).hashCode;

  Map<String, dynamic>  toMap() {
    Map<String, dynamic> map = {
              CategoryProvider.columnId: id,
              CategoryProvider.columnGroupId: groupId,
              CategoryProvider.columnText: text,
              CategoryProvider.columnCount: count
            } ;

    return map;
  }

  Category.fromMap(Map map) {

            id = map[CategoryProvider.columnId];
            groupId = map[CategoryProvider.columnGroupId];
            text = map[CategoryProvider.columnText];
            count = map[CategoryProvider.columnCount];
  }
}