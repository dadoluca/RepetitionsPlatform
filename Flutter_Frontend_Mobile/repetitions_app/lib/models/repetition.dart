import 'package:flutter/material.dart';

class Repetition {
  final int id;
  final int courseId;
  final String userId;
  final int availabilityId;
  final int teacherId;
  final String teacherName;
  final String teacherSurname;
  final String teacherImg;
  final String courseName;
  final String startDate;
  final String endDate;
   int state;

  Repetition({@required this.id, this.courseId, this.userId, @required this.availabilityId,
  this.teacherId, this.teacherName, this.teacherSurname, this.teacherImg, this.courseName,
  this.startDate, this.endDate, this.state});

}
