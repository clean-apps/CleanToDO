
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/calender/DateUtil.dart';
import 'package:clean_todo/data/TaskProvider.dart';
import 'package:clean_todo/beans/CategoryData.dart';

class Task {

  Task({  this.id, this.completed, this.title, this.category,
          this.deadline_val, this.reminder_date, this.reminder_time,
          this.repeat, this.notes });

  int id;
  bool completed ;
  String title ;
  Category category ;

  get deadline{
    return DateUtil.detect_desc( deadline_val );
  }

  String deadline_val ;
  
  get reminder {
    if( reminder_date == null ) return null;
    else return DateUtil.detect_desc( reminder_date ) + ' @ ' + reminder_time;
  }

  String reminder_date ;
  String reminder_time ;
  int repeat ;

  String notes ;

  bool get isDue{

    if( completed )
      return false;

    else if ( deadline_val == null )
      return false;

    else if ( DateTime.parse( deadline_val ).isBefore( DateUtil.tomorrow ) )
      return true;

    else
      return false;

  }

  copy( Task from ){
    this.id = from.id;
    this.title = from.title;
    this.completed = from.completed;
    this.category = from.category.clone();
    this.deadline_val = from.deadline_val;
    this.reminder_date = from.reminder_date;
    this.reminder_time = from.reminder_time;
    this.repeat = from.repeat;
    this.notes = from.notes;

  }

  clear(){
    this.id = null;
    this.title = null;
    this.completed = false;
    this.category = null;
    this.deadline_val = null;
    this.reminder_date = null;
    this.reminder_time = null;
    this.repeat = null;
    this.notes = null;
  }

  Task clone(){
    return new Task(  id: id,
                      title: title,
                      completed: completed,
                      category: category.clone(),
                      deadline_val: deadline_val,
                      reminder_date: reminder_date,
                      reminder_time: reminder_time,
                      repeat: repeat,
                      notes: notes,
    );
  }

  bool operator ==(o) => o.id == this.id;
  int get hashCode =>  this.id.toString().hashCode;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
        //TaskProvider.columnId: id,
        TaskProvider.columnTitle: title,
        TaskProvider.columnCompleted: completed == true ? 1 : 0,
        TaskProvider.columnCategoryId: category.id,
        TaskProvider.columnDeadlineVal: deadline_val,
        TaskProvider.columnReminderDate: reminder_date,
        TaskProvider.columnReminderTime: reminder_time,
        TaskProvider.columnRepeat: repeat,
        TaskProvider.columnNotes: notes,

    };

    if (id != null) {
      map[TaskProvider.columnId] = id;
    }

    //print( "map => " + map.type.reflectedType.toString() );
    return map;
  }

  Task.fromMap( Map map, CategoryData categoryData ) {

      id = map[TaskProvider.columnId];
      title = map[TaskProvider.columnTitle];
      completed = map[TaskProvider.columnCompleted] == 1;
      category = categoryData.getCategory( map[TaskProvider.columnCategoryId] );
      deadline_val = map[TaskProvider.columnDeadlineVal];
      reminder_date = map[TaskProvider.columnReminderDate];
      reminder_time = map[TaskProvider.columnReminderTime];
      repeat = map[TaskProvider.columnRepeat];
      notes = map[TaskProvider.columnNotes];
  }

}