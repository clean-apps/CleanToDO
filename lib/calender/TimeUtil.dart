import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtil {

  static get now {
    return new TimeOfDay.now();
  }

  static get reminder_time_val{
    if( (new TimeOfDay.now()).hour > 9 ){
      return '2100';
    } else {
      return '0900';
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
    return new TimeOfDay( hour:   int.parse(val.substring(0,1)),
                          minute: int.parse(val.substring(2,3))
            );
  }

  static TimeOfDay parse_back( String val ){
    return parse_string(val);
  }
}