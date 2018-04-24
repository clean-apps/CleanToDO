
import 'package:clean_todo/beans/Category.dart';

class Task {

  Task({ this.id, this.completed, this.title, this.category, this.deadline, this.reminder, this.notes });

  int id;
  bool completed ;
  String title ;
  Category category ;
  String deadline ;
  String reminder ;
  String repeat ;
  String notes ;

  get hashCode =>  this.id;

}