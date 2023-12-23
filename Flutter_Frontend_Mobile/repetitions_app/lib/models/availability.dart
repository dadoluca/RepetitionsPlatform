import 'package:flutter/material.dart';
class Availability {
  final int id;
  final String startDate;
  final String endDate;
  final int teacherId;
  final int day; // 0 (Mon) - 6 (Sun)
  final String startHour;
  final String endHour;
  bool _booked;
  bool _bookedByUser;

  Availability({@required this.id, @required this.startDate, @required this.endDate, @required this.teacherId,
    this.day, this.startHour, this.endHour, bool booked, bool bookedByUser}) :
        _booked = booked,
        _bookedByUser = bookedByUser;

  bool get booked => _booked;
  set booked(bool value) => _booked = value;

  bool get bookedByUser => _bookedByUser;
  set bookedByUser(bool value) => _bookedByUser = value;
}
