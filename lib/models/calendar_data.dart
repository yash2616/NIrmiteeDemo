import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';

class CalendarData extends ChangeNotifier{
  CalendarApi? calendar;

  List<Event>? events;

  Map<String, List<Event>>? dateEvent;

  void updateDateEvent(){
    notifyListeners();
  }
}