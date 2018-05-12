import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtil {

  static get now {
    return new TimeOfDay.now();
  }

  static get reminder_time_val{
    if( (new TimeOfDay.now()).hour > 9 ){
      return '21:00';
    } else {
      return '09:00';
    }
  }

  static get reminder_time{
    if( (new TimeOfDay.now()).hour > 9 ){
      return '21';
    } else {
      return '09';
    }
  }

  static parse( TimeOfDay val ){
    return val.hour.toString().padLeft(2, '0')  +
            ':' +
           val.minute.toString().padLeft(2, '0');
  }

  static TimeOfDay parse_string( String val ){
    print( "parsing -" + val  + " ~ part1:" + val.substring(0,2) + " ~ part2:" + val.substring(3,5) );
    return new TimeOfDay( hour:   int.parse(val.substring(0,2)),
                          minute: int.parse(val.substring(3,5))
            );
  }

  static TimeOfDay parse_back( String val ){
    return parse_string(val);
  }
}