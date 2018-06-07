import 'package:live_schdlue_app/datamodel/StationData.dart';

class Schedule {
  Data current;
  List<Data> upcoming;

  Schedule.fromMap(Map<String, dynamic> jsonMap) {
    Map dataMap = jsonMap["data"];
    Map siteMap = dataMap["site"];
    Map scheduleMap = siteMap["schedule"];
    Map currentMap = scheduleMap["current"];

    current = new Data.fromMap(currentMap);
    List upcomingMap = scheduleMap["upcoming"];
    this.upcoming = new List<Data>();

    for(Map item in upcomingMap) {
      Data data = new Data.fromMap(item);
      this.upcoming.add(data);
    }
  }

}

class Destination {
  String href;
  String thumbnail;

  Destination.fromMap(Map dataMap) {
    Map destination = dataMap["destination"];
    this.href = destination["href"];
    this.thumbnail = destination["thumbnail"];

    if(!this.thumbnail.startsWith("http")) {
      this.thumbnail = "http:"+this.thumbnail;
    }
  }
}


class Data {
  String name;
  int core_show_id;
  String start;
  String stop;
  Destination destination;
  DateTime startTime;
  DateTime endTime;

  Data.fromMap(Map dataMap) {
    name = dataMap["name"];
    core_show_id = dataMap["core_show_id"];
    start = dataMap["start"];
    stop = dataMap["stop"];

    destination = new Destination.fromMap(dataMap);
  }

  setStartTime(DateTime startTime) {
    this.startTime = startTime;
  }

  setEndTime(DateTime endTime) {
    this.endTime;
  }

}

class ScheduleData {

  Data data;
  StationData stationData;
  String name;
  int core_show_id;
  String start;
  String stop;
  Destination destination;
  DateTime startTime;
  DateTime endTime;
  String displayName;
  String stationDescription;

  ScheduleData(final Data orgData,
               final StationData stationData) {
    this.data = orgData;
    this.startTime = orgData.startTime;
    this.endTime = orgData.endTime;
    this.name = orgData.name;
    this.destination = orgData.destination;
    this.stationData = stationData;
    this.core_show_id = orgData.core_show_id;
    this.start = orgData.start;
    this.stop = orgData.stop;
    this.displayName = stationData.displayName;
  }


}