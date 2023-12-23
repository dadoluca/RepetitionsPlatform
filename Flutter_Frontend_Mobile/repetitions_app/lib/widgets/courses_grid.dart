import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repetitions_app/widgets/course_item.dart';

import '../providers/courses.dart';

class CoursesGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //----- prelevo la lista di corsi
    final coursesData = Provider.of<Courses>(context, listen: false);
    final courses = coursesData.courses;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: courses.length,
      itemBuilder: (ctx, i) => CourseItem(courses[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 6 / 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
    );
  }
}
