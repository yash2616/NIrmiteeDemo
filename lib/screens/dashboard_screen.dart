import 'dart:io';

import 'package:calender/models/calendar_data.dart';
import "package:flutter/material.dart";
import 'package:googleapis/calendar/v3.dart' hide Colors;
// import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'calendar_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key, required this.calendarData}) : super(key: key);

  final _credentials = ClientId("111864899159-franrid96u8pnf6edgk3h02catpm91vj.apps.googleusercontent.com", "");

  final CalendarData calendarData;

  Map<String,List<Event>> dateEvent = {

  };

  // void createClientId() async{
  //   if (Platform.isAndroid) {
  //     _credentials = ClientId(
  //         "111864899159-franrid96u8pnf6edgk3h02catpm91vj.apps.googleusercontent.com",
  //         "");
  //   }
  // }

  insertEvent(BuildContext context) async{
    try {
      await clientViaUserConsent(
          _credentials,
          ['https://www.googleapis.com/auth/calendar.events'],
          prompt)
      .then((AuthClient client) async{
        var calendar = CalendarApi(client);
        calendarData.calendar = calendar;
        String calendarId = "primary";
        var events = await calendar.events.list(calendarId);
        Provider.of<CalendarData>(context, listen: false).events = events.items;
        events.items?.forEach((e){
          if(e.start?.dateTime!=null){
            if(dateEvent["${e.start?.dateTime?.year}-${e.start?.dateTime?.month}-${e.start?.dateTime?.day}"] == null){
              dateEvent["${e.start?.dateTime?.year}-${e.start?.dateTime?.month}-${e.start?.dateTime?.day}"] = [e];
            }
            else{
              dateEvent["${e.start?.dateTime?.year}-${e.start?.dateTime?.month}-${e.start?.dateTime?.day}"]!.add(e);
            }
          }
        });
        print(dateEvent);
        Provider.of<CalendarData>(context, listen: false).dateEvent = dateEvent;
      });
    } catch (e) {
      print('Error creating event $e');
    }
  }

  void prompt(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nirmitee Demo"),
        elevation: 0,
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.white,
          child: const Text(
            "Take a peek",
            // style: TextStyle(
            //   color: Colors.white
            // ),
          ),
          onPressed: () async {
            await insertEvent(context);
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return CalendarScreen();
            }));
          },
        ),
      ),
    );
  }
}
