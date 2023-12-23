import 'package:flutter/material.dart';

class Teacher {
  final int id;
  final String email;
  final String name;
  final String surname;
  final String sex;
  final int prize;
  final int age;
  final String degree;
  final String imageUrl;
  final String imageUrlUniversity;

  Teacher({@required this.id, @required this.email, @required this.name, @required this.surname,
  @required this.prize,  this.sex, this.age, this.degree, this.imageUrl, this.imageUrlUniversity});
}
