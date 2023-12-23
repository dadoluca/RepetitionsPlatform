import 'package:flutter/material.dart';

class Course {
  final int id;
  final String name;
  final String imageUrl;

  Course({@required this.id, @required this.name, this.imageUrl});
}
