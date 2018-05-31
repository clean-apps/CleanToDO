import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/CategoryGroup.dart';

class CategoryData {

  CategoryData({ this.system, this.userGroups, this.user });

  List<Category> system = [];
  List<CategoryGroup> userGroups = [];
  List<Category> user = [];

  List<Category> getGroupMembers ( CategoryGroup group ){

    List<Category> groupCategories =  user.map( (userCategory) {
        if( userCategory.groupId == group.id ){
          return userCategory;
        }
    }).toList();

    groupCategories.removeWhere( (category) => category == null );
    return groupCategories;
  }

  Category getCategory( int categoryId ){
    return user.where( (category) => category.id == categoryId ).first;

  }

  CategoryGroup getCategoryGroup( int categoryId ){
    Category category = getCategory(categoryId);
    return userGroups.where( (categoryGroup) => categoryGroup.id == category.groupId ).first;
  }

}