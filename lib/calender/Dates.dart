import "package:intl/intl.dart";

class Dates {

  static get today{
    DateTime timeIsNow = new DateTime.now();
    return new DateTime( timeIsNow.year, timeIsNow.month, timeIsNow.day, 0, 0, 0, 0, 0 );
  }

  static get tomorrow{
    DateTime timeIsNow = new DateTime.now().add( new Duration(days: 1) );
    return new DateTime( timeIsNow.year, timeIsNow.month, timeIsNow.day, 0, 0, 0, 0, 0 );
  }

  static get next_week{
    DateTime timeIsNow = new DateTime.now();
    int daysToNextMonday = 8 - timeIsNow.weekday;
    timeIsNow = timeIsNow.add( new Duration(days: daysToNextMonday) );

    return new DateTime( timeIsNow.year, timeIsNow.month, timeIsNow.day, 0, 0, 0, 0, 0 );
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
    if( 'Today' == val ){
      return parse( today );

    } else if( 'Tomorrow' == val ){
      return parse( tomorrow );

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

    } else if( parse( next_week) == formatted ){
      return 'Next Week';

    } else if ( formatted != null ){
      return format( DateTime.parse( formatted ) );

    } else {
      return null;
    }
  }

}