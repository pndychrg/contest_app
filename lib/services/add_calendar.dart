import 'package:add_2_calendar/add_2_calendar.dart';

class AddCalendar {
  Event _event(String title, DateTime startDate, DateTime endDate) {
    return Event(
      title: title,
      startDate: startDate,
      endDate: endDate,
    );
  }

  addToCalendar(String title, DateTime startDate, DateTime endDate) {
    Add2Calendar.addEvent2Cal(_event(title, startDate, endDate));
  }
}
