class Dates {

  static get now{
    DateTime timeIsNow = new DateTime.now();
    return new DateTime( timeIsNow.year, timeIsNow.month, timeIsNow.day, 0, 0, 0, 0, 0 );
  }

  static parse( DateTime val ){
    return val.year.toString() +
           val.month.toString().padLeft(2, '0')  + 
           val.day.toString().padLeft(2, '0') ;
  }

}