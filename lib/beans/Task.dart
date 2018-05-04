
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/calender/DateUtil.dart';

class Task {

  Task({ this.id, this.completed, this.title, this.category, this.deadline_val, this.reminder_date, this.reminder_time, this.notes });

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

  get hashCode =>  this.id;

}