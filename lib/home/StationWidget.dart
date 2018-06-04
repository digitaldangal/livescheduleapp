import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live_schdlue_app/datamodel/StationData.dart';

class StationWidget extends StatelessWidget {

   final StationData stationData;

   StationWidget(this.stationData);

  void onClicked(String value) {
    /**
     *
     */
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                stationData.name,
                textAlign: TextAlign.left,
                style: new TextStyle(fontSize: 18.0),
              ),
            ),
            new Expanded(
                child: new TextField(
                  //controller: controller,
                  onSubmitted: onClicked,
                )
            ),
          ]
      ),
    );
  }
}