import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';

class CalendarEventTypeStyle {
  final Color backgroundColor;
  final IconData icon;

  CalendarEventTypeStyle({required this.backgroundColor, required this.icon});
}

final Map<CalendarEventType, CalendarEventTypeStyle> calendarStylesEvent = {
  CalendarEventType.avaliacao: CalendarEventTypeStyle(
    backgroundColor: Colors.redAccent,
    icon: CupertinoIcons.doc_text_fill,
  ),
  CalendarEventType.reuniao: CalendarEventTypeStyle(
    backgroundColor: Colors.orangeAccent,
    icon: CupertinoIcons.person_2_fill,
  ),
  CalendarEventType.eventoEscolar: CalendarEventTypeStyle(
    backgroundColor: Colors.purpleAccent,
    icon: CupertinoIcons.calendar_badge_plus,
  ),
  CalendarEventType.outro: CalendarEventTypeStyle(
    backgroundColor: Colors.blueAccent,
    icon: CupertinoIcons.square_list_fill,
  ),
};
