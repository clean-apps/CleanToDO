import 'package:clean_todo/data/CategoryGroupProvider.dart';

class CategoryGroup {

  int id;
  String text ;
  bool isExpanded ;

  CategoryGroup({ this.id, this.text, this.isExpanded = true });

  CategoryGroup clone(){
    return new CategoryGroup( id: id, text: text, isExpanded: isExpanded );
  }

  int get hashCode => text.hashCode;

  Map<String, dynamic>  toMap() {
    Map<String, dynamic> map = {
            CategoryGroupProvider.columnId: id,
            CategoryGroupProvider.columnText: text,
    } ;

    return map;
  }

  CategoryGroup.fromMap(Map map) {

    id = map[CategoryGroupProvider.columnId];
    text = map[CategoryGroupProvider.columnText];
  }
}