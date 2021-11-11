import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' hide Colors;

class EventTile extends StatelessWidget {
  const EventTile({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(5.0),

      color: Colors.lightBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.summary??'No name',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
          SizedBox(
            height: 5
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${event.start?.dateTime?.hour??''}:${event.start?.dateTime?.minute == 0 ? '00' : event.start?.dateTime?.minute ??''}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "${event.end?.dateTime?.hour??''}:${event.end?.dateTime?.minute == 0 ? '00' : event.end?.dateTime?.minute ?? ''}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
}
