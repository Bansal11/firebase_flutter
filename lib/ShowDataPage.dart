import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/myData.dart';

class ShowDataPage extends StatefulWidget {
  @override
  _ShowDataPageState createState() => _ShowDataPageState();
}

class _ShowDataPageState extends State<ShowDataPage> {
  List<myData> allData = [];

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var devices = ref.child('bmu-hackathon').child('temperature');
    devices.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        myData d = new myData(
          data[key]['date'],
          data[key]['time'],
          data[key]['value'],
        );
        allData.add(d);
      }
      setState(() {
        print('Length : ${allData.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Firebase Data'),
      ),
      body: new Container(
          child: allData.length == 0
              ? new Text(' No Data is Available')
              : new ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (_, index) {
                    return UI(
                      allData[index].name,
                      allData[index].profession,
                      allData[index].message,
                    );
                  },
                )),
    );
  }

  Widget UI(String name, String profession, String message) {
    return new Card(
      elevation: 10.0,
      child: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text('Name : $name',style: Theme.of(context).textTheme.title,),
            new Text('Profession : $profession'),
            new Text('Message : $message'),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'resource.dart';
import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

class Home extends StatefulWidget{

  @override
  HomeState createState() => HomeState();

}

class HomeState extends State<Home> {

  static List<myData> allData = []

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var devices = ref.child('bmu-hackathon').child('temperature');
    devices.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        myData d = new myData(
          data[key]['date'],
          data[key]['time'],
          data[key]['value'],
        );
        allData.add(d);
      }
      setState(() {
        print('Length : ${allData.length}');
      });
    });
  }

@override
Widget build (BuildContext context) {

  // TODO: implement build
  return MaterialApp(
    home: Scaffold(
        body: allData.length == 0 ? new Text('no data') :
        RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    height: 500.0,
                    child: Stack(
                      children: <Widget>[
                        new Positioned(
                          child: new CircleButton(onTap: () => print(allData[0].value), iconLabel: 'bulb', size: 100.0),
                          top: 50.0,
                          left: 30.0,
                        ),
                        new Positioned(
                          child: new CircleButton(onTap: () => print("Cool"), iconLabel: 'charger', size: 100.0),
                          top: 300.0,
                          left: 10.0,
                        ),
                        new Positioned(
                          child: new CircleButton(onTap: () => print("Cool"), iconLabel: 'hair dryer', size: 100.0),
                          top: 200.0,
                          right: 10.0,
                        ),
                      ],
                    ),
                  ),
                  new ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return UI(allData[index].date, allData[index].time,
                          allData[index].value);
                    }, itemCount: allData.length,
                  )
                ]
            )
        )
    ),
  );
}

Widget UI (String date, String time, String value) {
  return new Card(
    child: new Container(
      child: new Column(
        children: <Widget>[
          new Text('date: $date'),
          new Text('time: $time'),
          new Text('vale: $value'),
        ],
      ),
    ),
  );

}

Future<Null> refresh() async {
  await Future.delayed(Duration(seconds: 2));
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  var devices = ref.child('bmu-hackathon').child('temperature');

  devices.once().then((DataSnapshot snap) {
    var keys = snap.value.keys;
    var data = snap.value;
    allData.clear();
    for (var key in keys) {
      setState(() {
        allData.add(
            new myData(data[key]['date'], data[key]['time'], data[key]['value'])
        );
      });

    }

  });
  return null;
}

Widget bigCircle = new Container(
  width: 300.0,
  height: 300.0,
  child: Center(child: Text('bulb')),
  decoration: new BoxDecoration(
    color: Colors.orange,
    shape: BoxShape.circle,
  ),
);


class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String iconLabel;
  final double size;


  const CircleButton({Key key, this.onTap, this.iconLabel, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    double size = 100.0;
    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Color.fromRGBO(176, 0, 32, 1.0),
          shape: BoxShape.circle,
        ),
        child: Center(child: Text('$iconLabel')),
      ),
    );
  }
}


