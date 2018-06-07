import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live_schdlue_app/ListOfStationsManager.dart';
import 'package:live_schdlue_app/StationGridEntryWidget.dart';
import 'package:live_schdlue_app/animations/Animations.dart';
import 'package:live_schdlue_app/datamodel/StationData.dart';
import 'package:live_schdlue_app/home/PageContainer.dart';

class StationSelectWidget extends StatefulWidget {
  StationSelectWidget({Key key, this.title, this.zipCode}) : super(key: key);

  final String title;
  final String zipCode;

  @override
  _StationSelectWidgetState createState() => new _StationSelectWidgetState();
}

class _StationSelectWidgetState extends State<StationSelectWidget>
    with TickerProviderStateMixin {
  final ListOfStationsManager manager = new ListOfStationsManager();
  HashMap<String, StationData> selectedStations = new HashMap();

  FlyingRadioAnimationController flyingRadioAnimationController;

  @override
  void initState() {
    super.initState();
    flyingRadioAnimationController = new FlyingRadioAnimationController();
    flyingRadioAnimationController.init(this, this);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Stack(fit: StackFit.passthrough, children: <Widget>[
          new Center(
              child: new FutureBuilder<List<StationData>>(
            future: manager.getStationsByZipCode(widget.zipCode),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(10.0),
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    crossAxisCount: 2,
                    children: _buildStationList(snapshot.data));
              }

              return new CircularProgressIndicator();
            },
          )),
          buildFlyingRadios(),
        ]),
        floatingActionButton: new FloatingActionButton(
          onPressed: animateFlyingRadios,
          tooltip: 'Continue To Schedule Builder',
          child: new Container(
//            width: flyingRadioAnimationController.getAnimValue(),
//            height: flyingRadioAnimationController.getAnimValue(),
            transform: new Matrix4.translationValues(
              0.0,
              0.0,
              0.0,
            ),
            child: new AnimatedIcon(
              icon: AnimatedIcons.add_event,
              progress: flyingRadioAnimationController.getIconAnim()
            )
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  Widget buildFlyingRadios() {
    return new Transform(
        transform: new Matrix4.translationValues(
          flyingRadioAnimationController.getAnimValue(),
          0.0,
          0.0,
        ),
        child: new Icon(Icons.map));

    //return new Icon(Icons.map);
  }

  List<StationGridEntryWidget> _buildStationList(List<StationData> stations) {
    return stations
        .map((stationData) =>
            new StationGridEntryWidget(stationData, toggledStationCallback))
        .toList();
  }

  void toggledStationCallback(StationData stationData, bool newState) {
    print("toggled : " + stationData.id + " : " + newState.toString());
    if (newState) {
      selectedStations.putIfAbsent(stationData.id, () => stationData);
    } else {
      selectedStations.remove(stationData.id);
    }
  }

  void animateFlyingRadios() {
    //spawn a radio icon from each selected item and send them to the next button location
    flyingRadioAnimationController._triggerAnimation(true);

    flyingRadioAnimationController._animationController.addStatusListener((status) {

      if (status == AnimationStatus.completed) {
        continueToScheduleView();
      }

    });


    //when animations are done continue to the next page
  }

  void continueToScheduleView() {
    final List<StationData> stationDatas = selectedStations.values.toList();

    if (stationDatas.isNotEmpty) {
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new PageContainer(
                  title: "Station Select Widget",
                  stationsDatas: stationDatas,
                )),
      );
    }
  }
}

//class FlyingRadio extends StatelessWidget {
//  // This widget is the root of your application.
//
//  FlyingRadioAnimationController animationController;
//
//  @override
//  Widget build(BuildContext context) {
//    return new Icon(Icons.ac_unit);
//  }
//}

class FlyingRadioAnimationController {
  GenericAnimationController _moveController;



  Duration animDuration = const Duration(milliseconds: 1000);


  AnimationController _animationController;
  Animation<double>_animateIcon;

  void init(State state, TickerProvider tp) {

    _animationController =
    AnimationController(vsync: tp, duration: Duration(milliseconds: 500))
      ..addListener(() {
        state.setState(() {});
      });

    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

//    _animationController.addStatusListener((status) {
//      //when anim is done play it in reverse
//      if (status == AnimationStatus.completed) {
//        _animationController.reverse();
//      }
//    });



    initMoveAnim(state, tp);
  }

  void initMoveAnim(State state, TickerProvider tp) {
    _moveController = new GenericAnimationController(
        animDuration, tp, state, true, 0.0, 500.0);
  }

  double getAnimValue() {
    return _moveController.getAnimation().getValue();
  }

  Animation<double> getIconAnim() {
    return _animateIcon;
  }

  void _triggerAnimation(bool active) {
    print("Triggering anim");
    TickerFuture tf; //listener for anim done
    tf = _moveController.forward();
    _animationController.forward();

    tf.whenCompleteOrCancel(() {
      _animDone(active);
    });
  }

  void _animDone(bool active) {
    print("Anim is done : " + active.toString());
  }
}
