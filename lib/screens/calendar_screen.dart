// import 'package:calender/models/calendar_data.dart';
import 'package:calender/widgets/month_header.dart';
import 'package:calender/widgets/month_row.dart';
// import 'package:calender/widgets/round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' hide Colors;
// import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  Map monthData = {
    1: {
      "name": "January",
      "days": 31,
    },
    2: {
      "name": "February",
      "days": 28,
    },
    3: {
      "name": "March",
      "days": 31,
    },
    4: {
      "name": "April",
      "days": 30,
    },
    5: {
      "name": "May",
      "days": 31,
    },
    6: {
      "name": "June",
      "days": 30,
    },
    7: {
      "name": "July",
      "days": 31,
    },
    8: {
      "name": "August",
      "days": 31,
    },
    9: {
      "name": "September",
      "days": 30,
    },
    10: {
      "name": "October",
      "days": 31,
    },
    11: {
      "name": "November",
      "days": 30,
    },
    12: {
      "name": "December",
      "days": 31,
    },
  };

  List<Widget> monthRows = [MonthHeader()];

  void method(){
    DateTime today = DateTime.now();
    int currentMonth = today.month;
    int totalDays = monthData[currentMonth]["days"];
    int tDays = totalDays;
    DateTime firstDate = DateTime(today.year,currentMonth,1);
    int weekday = firstDate.weekday-1;
    print(weekday);
    int start = 1;
    // totalDays += 7-weekday;
    while(totalDays>=1){
      monthRows.add(MonthRow(
        gap: weekday,
        start: start,
        limit: tDays,
        month: currentMonth,
        year: today.year,
      ));
      start += 7;
      start -= weekday;
      totalDays -= 7;
      weekday=0;
    }
    Widget monthHeading = Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Center(
        child: Text(
          "${monthData[currentMonth]['name']}, ${today.year}",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
    monthRows.insert(0,monthHeading);
  }

  @override
  void initState() {
    // TODO: implement initState
    method();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: monthRows,
      ),
    );
  }
}
