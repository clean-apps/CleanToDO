import "package:intl/intl.dart";

class DateUtil {

  static get today{
    DateTime timeIsNow = new DateTime.now();
    return new DateTime( timeIsNow.year, timeIsNow.month, timeIsNow.day, 0, 0, 0, 0, 0 );
  }

  static get tomorrow{
    DateTime timeIsNow = new DateTime.now().add( new Duration(days: 1) );
    return new DateTime( timeIsNow.year, timeIsNow.month, timeIsNow.day, 0, 0, 0, 0, 0 );
  }

  static get yesterday{
    DateTime timeIsNow = new DateTime.now().add( new Duration(days: -1) );
    return new DateTime( timeIsNow.year, timeIsNow.month, timeIsNow.day, 0, 0, 0, 0, 0 );
  }

  static get next_week{
    DateTime timeIsNow = new DateTime.now();
    int daysToNextMonday = 8 - timeIsNow.weekday;
    timeIsNow = timeIsNow.add( new Duration(days: daysToNextMonday) );

    return new DateTime( timeIsNow.year, timeIsNow.month, timeIsNow.day, 0, 0, 0, 0, 0 );
  }

  static get last_week_start{
    DateTime timeIsNow = new DateTime.now();
    int daysToNextMonday = 8 - timeIsNow.weekday;
    timeIsNow = timeIsNow.add( new Duration(days: daysToNextMonday) );
    DateTime timeWeekStart = timeIsNow.subtract( new Duration( days: 14 ) );

    return new DateTime( timeWeekStart.year, timeWeekStart.month, timeWeekStart.day, 0, 0, 0, 0, 0 );
  }

  static get last_week_end{
    DateTime timeIsNow = new DateTime.now();
    int daysToNextMonday = 8 - timeIsNow.weekday;
    timeIsNow = timeIsNow.add( new Duration(days: daysToNextMonday) );
    DateTime timeWeekEnd = timeIsNow.subtract( new Duration( days: 8 ) );

    return new DateTime( timeWeekEnd.year, timeWeekEnd.month, timeWeekEnd.day, 0, 0, 0, 0, 0 );
  }

  static parse( DateTime val ){
    return val.year.toString() +
           val.month.toString().padLeft(2, '0')  + 
           val.day.toString().padLeft(2, '0') ;
  }

  static format( DateTime val ){
    return new DateFormat( DateFormat.ABBR_MONTH_DAY ).format( val );
  }

  static parse_string( String val ){

    if( val != null && val.startsWith('Due ') ){
      val = val.replaceFirst( 'Due ', '');
    }

    if( 'Later Today' == val ) {
      return parse(today);

    }else if( 'Today' == val ){
      return parse( today );

    } else if( 'Tomorrow' == val ) {
      return parse(tomorrow);

    }else if( 'Yesterday' == val ){
      return parse( yesterday );

    } else  if( 'Next Week' == val ){
      return parse( next_week );

    } else {
      return val;
    }
  }

  static detect_desc( String formatted ){
    if( parse( today ) == formatted ){
      return 'Today';

    } else if( parse( tomorrow) == formatted ){
      return 'Tomorrow';

    } else if( parse( yesterday ) == formatted ){
      return 'Yesterday';

    } else if( parse( next_week) == formatted ){
      return 'Next Week';

    } else if ( formatted != null ){
      return format( DateTime.parse( formatted ) );

    } else {
      return null;
    }
  }

}