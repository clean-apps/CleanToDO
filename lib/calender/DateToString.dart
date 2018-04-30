
class DateToString {

   static final DateTime today = new DateTime.now();
   static final DateTime tomorrow = new DateTime.now().add( new Duration( days: 1 ) );
   static final DateTime next_week = new DateTime.now().add( new Duration( days: 7 ) );

  static parse( DateTime pVar ){

    if( pVar == today ) return 'Today';
    else if ( pVar == tomorrow ) return 'Tomorrow';
    else if ( pVar == next_week ) return 'Next Week';
    else return 'Unknown';

  }

}