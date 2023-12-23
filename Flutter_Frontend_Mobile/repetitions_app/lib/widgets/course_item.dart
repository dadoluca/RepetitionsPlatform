import 'package:flutter/material.dart';
import 'package:repetitions_app/screens/course_teachers_screen.dart';
import 'package:repetitions_app/variables/my_colors.dart';
import 'dart:io' show Platform;

import 'package:repetitions_app/widgets/my_image.dart';
import '../models/course.dart' as courseModel;

class CourseItem extends StatelessWidget {
  final courseModel.Course course;

  const CourseItem(this.course);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor:
              myColors.tertiary.withOpacity(0.50),
          title: Text(
            course.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              CourseTeachersScreen.routeName,
              arguments: { 'courseId': course.id,
              'courseName': course.name,
              },
            );
          },
          child: Image.network(
            course.imageUrl,
            fit: BoxFit.cover,
          ),
         // child: MyImage(course.imageUrl),
        ),
      ),
    );
  }
}
