import 'package:calender/models/calendar_data.dart';
import 'package:calender/widgets/add_event_sheet.dart';
import 'package:calender/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' hide Colors;
import 'package:provider/provider.dart';

class EventCard extends StatelessWidget {
  EventCard({Key? key, required this.childText, this.eventCount, required this.events, this.dateTime}) : super(key: key);

  final String childText;
  final int? eventCount;
  final List<Event> events;
  final DateTime? dateTime;

  String title = "";
  String desc = "";
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Event? newEvent;

  void addEvent(BuildContext context){
    print(title);
    newEvent = Event();
    newEvent!.summary = title;
    newEvent!.description = desc;
    newEvent!.start = EventDateTime(
      dateTime: DateTime(dateTime!.year,dateTime!.month,dateTime!.day,startTime!.hour,startTime!.minute),
      timeZone: "GMT+05:30",
    );
    newEvent!.end = EventDateTime(
      dateTime: DateTime(dateTime!.year,dateTime!.month,dateTime!.day,endTime!.hour,endTime!.minute),
      timeZone: "GMT+05:30",
    );

    Navigator.pop(context,newEvent);
  }

  void onEventTap(BuildContext context) async{
    if(childText=="-"){
      return;
    }
    var choice = await showDialog(context: context, builder: (context){
      return Dialog(
        child: Container(
          height: 400.0,
          child: Column(
              children: [
                Text("${dateTime!.day}-${dateTime!.month}-${dateTime!.year}"),
                Expanded(
                  flex: 4,
                  child: ListView(
                      children: events!.map((e){
                        return EventTile(
                          event: e,
                        );
                      }).toList()
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      elevation: 5,
                      color: Colors.blueGrey,
                      onPressed: (){
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        "Create Event",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
      );
    });
    if(choice==true){
      showAddEventSheet(context);
    }
  }

  void showAddEventSheet(BuildContext context) async{
    var event = await showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: 400,
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              // textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Title",
                // border: InputBorder.none,
              ),
              onChanged: (newValue){
                title = newValue;
              },
            ),
            TextField(
              autofocus: true,
              // textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Description",
                // border: InputBorder.none,
              ),
              onChanged: (newValue){
                desc = newValue;
              },
            ),
            FlatButton(
              onPressed: ()async{
                var time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
                if(time!=null){
                  startTime = time;
                }
              },
              child: Text("Select start time"),
            ),
            FlatButton(
              onPressed: ()async{
                var time = await showTimePicker(context: context, initialTime: startTime ?? TimeOfDay.fromDateTime(DateTime.now()));
                if(time!=null){
                  endTime = time;
                }
              },
              child: Text("Select end time"),
            ),
            RaisedButton(
              color: Colors.lightBlue,
              elevation: 5,
              onPressed: (){
                if(title!="" && startTime!=null && endTime!=null){
                  addEvent(context);
                }
                else{
                  print("Enter valid fields...");
                }
              },
              child: Text("Add Event", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    });
    print(event.summary);
    Provider.of<CalendarData>(context, listen: false).calendar!.events.insert(event,"primary").then((value){
      print("ADDED_________________${value.status}");
      if (value.status == "confirmed") {
        print('Event added in google calendar');
        Provider.of<CalendarData>(context, listen: false).events!.add(value);
        if(Provider.of<CalendarData>(context, listen: false).dateEvent!["${dateTime!.year}-${dateTime!.month}-${dateTime!.day}"]!=null){
          Provider.of<CalendarData>(context, listen: false).dateEvent!["${dateTime!.year}-${dateTime!.month}-${dateTime!.day}"]!.add(value);
        }
        else{
          Provider.of<CalendarData>(context, listen: false).dateEvent!["${dateTime!.year}-${dateTime!.month}-${dateTime!.day}"] = [value];
        }
        Provider.of<CalendarData>(context, listen: false).updateDateEvent();
      } else {
        print("Unable to add event in google calendar");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarData>(
      builder: (context, model, wid){
        return GestureDetector(
          onTap: () => onEventTap(context),
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
            ),
            child: Stack(
              children: [
                model.dateEvent!["${dateTime!.year}-${dateTime!.month}-${dateTime!.day}"] != null && childText != "-" ? Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 20,
                    width: 20,
                    child: Center(
                        child: Text(
                          "${model.dateEvent!["${dateTime!.year}-${dateTime!.month}-${dateTime!.day}"]?.length ?? '-'}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.red,
                    ),
                  ),
                ) : Container(),
                Center(
                  child: Text(
                    childText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
