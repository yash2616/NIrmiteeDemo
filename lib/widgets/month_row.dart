import 'package:calender/models/calendar_data.dart';
import 'package:calender/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' hide Colors;
import 'package:provider/provider.dart';

class MonthRow extends StatelessWidget {
  MonthRow({Key? key, required this.start, required this.gap, required this.limit, required this.year,
    required this.month}) : super(key: key);

  final int start;
  int gap;
  final int limit;
  final int year;
  final int month;

  @override
  Widget build(BuildContext context) {
    int startDay = start-1;
    // startDay -= 1;
    return Container(
      height: (MediaQuery.of(context).size.height-100)/7,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [0,1,2,3,4,5,6].map((e) {
          if(gap!=0){
            gap-=1;
            return Expanded(
              child:  EventCard(
                childText: "-",
                eventCount: 0,
                events: [],
              ),
            );
          }
          startDay += 1;
          int event = 0;
          if(Provider.of<CalendarData>(context, listen: false).dateEvent!["$year-$month-$startDay"]!=null){
            event = Provider.of<CalendarData>(context, listen: false).dateEvent!["$year-$month-$startDay"]!.length;
          }
          return Expanded(
            child: EventCard(
              dateTime: DateTime(year,month,startDay),
              childText: startDay>limit ? '-' : '${startDay}',
              // Center(
              //   child: Text(
              //     startDay>limit ? '-' : '${startDay}',
              //     style: const TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold
              //     ),
              //   ),
              // ),
              eventCount: event,
              events: Provider.of<CalendarData>(context, listen: true).dateEvent!["$year-$month-$startDay"] ?? [],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Container(
//   padding: EdgeInsets.all(2.0),
//   decoration: BoxDecoration(
//     border: Border.all(color: Colors.blueGrey),
//   ),
//   child: Center(child: Text("${start>limit ? '-' : start}")),
// ),
