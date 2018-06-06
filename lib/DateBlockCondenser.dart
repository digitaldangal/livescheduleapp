import 'dart:async';
import 'dart:collection';

import 'package:live_schdlue_app/datamodel/StationData.dart';
import 'package:live_schdlue_app/datamodel/Station.dart';
import 'package:live_schdlue_app/datamodel/LiveProfileModel.dart';

class DateBlockCondenser {

  static final DateBlockCondenser _singleton = new DateBlockCondenser._internal();

  factory DateBlockCondenser() {
    return _singleton;
  }

  DateBlockCondenser._internal();




  //given a block of programs determine the largest time range that all fit into

  void test() {


    //All start times need to be the same
    DateTime z100start = StringToDateTime.convertScheduleTimeToDateTime("1 PM", "June 6");
    DateTime q1043start = StringToDateTime.convertScheduleTimeToDateTime("1 PM", "June 6");
    DateTime a66start =StringToDateTime.convertScheduleTimeToDateTime("1 PM", "June 6");
    //End times can vary
    DateTime z100end = StringToDateTime.convertScheduleTimeToDateTime("4 PM", "June 6");
    DateTime q1043end = StringToDateTime.convertScheduleTimeToDateTime("3 PM", "June 6");
    DateTime a66end =StringToDateTime.convertScheduleTimeToDateTime("4 PM", "June 6");

    Map<String, Duration> durations = new Map();
    durations["z100"] = z100end.difference(z100start);
    durations["q1043"] = q1043end.difference(q1043start);
    durations["a66"] = a66end.difference(a66start);


    //normalize all durations against a start time, then grab the smallest one

    durations.forEach((k,v) => print(k + " : " + v.toString()));

    durations.forEach((k,v) => print(k));

    var sortedKeys = durations.keys.toList(growable:false)
      ..sort((k1, k2) => durations[k1].compareTo(durations[k2]));
    LinkedHashMap sortedMap = new LinkedHashMap
        .fromIterable(sortedKeys, key: (k) => k, value: (k) => durations[k]);
    print(sortedMap);

    Duration lowestDuration = durations.values.toList()[0];
    print(lowestDuration);




    

  }






}




class StringToDateTime {

  static DateTime convertScheduleTimeToDateTime(String hourInput, String dateInput) {

      //Strings come in the format "2 PM" , "6 AM" etc.

      //Convert to 24 hour time

      int hourNumber =  int.parse( hourInput.split(" ")[0]);
      if(hourNumber == 12) { hourNumber = 0; }
      if(hourInput.contains("PM")) {
        hourNumber += 12;
      }

      print("Hour Number : " + hourNumber.toString());

      int minuteNumber = 0; //do we need sub-hour increments?



      //Going to ignore specific day for now and just use today until we get the concept of day from the schedule
      //String fullString = "2018-06-06 " + time;

      int yearNumber = 2018;
      int monthNumber = 6;
      int dayNumber = 6;

      DateTime dt = new DateTime(yearNumber, monthNumber, dayNumber, hourNumber, minuteNumber, 0, 0, 0);

      print("DateTime is : " + dt.toString());
      return dt;
  }
}