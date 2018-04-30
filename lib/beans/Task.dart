
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/calender/Dates.dart';

class Task {

  Task({ this.id, this.completed, this.title, this.category, this.deadline_val, this.reminder, this.notes });

  int id;
  bool completed ;
  String title ;
  Category category ;

  get deadline{
    return Dates.detect_desc( deadline_val );
  }
  String deadline_val ;
  
  String reminder ;
  String notes ;

  get hashCode =>  this.id;

}