import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repetitions_app/models/repetition.dart';
import 'package:repetitions_app/providers/availability.dart';
import 'package:repetitions_app/providers/repetitions.dart';
import 'package:repetitions_app/screens/admin_repetitions_screen.dart';
import 'package:repetitions_app/screens/auth_screen.dart';
import 'package:repetitions_app/screens/course_teachers_screen.dart';
import 'package:repetitions_app/screens/teacher_availability_screen.dart';
import 'package:repetitions_app/screens/user_repetitions_screen.dart';

import '/providers/auth.dart';
import '/providers/courses.dart';
import '/providers/teachers.dart';

import '/screens/courses_overview_screen.dart';
import '/variables/my_colors.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Auth Provider must be the first of the list
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Courses>(
          create: (ctx) => Courses(null,null,null,[]),
          update: (ctx, auth, previousCourses) => Courses(
              auth.token,
              auth.userEmail,
              auth.userRole,
              previousCourses == null ? [] : previousCourses.courses),
        ),
        ChangeNotifierProxyProvider<Auth, Teachers>(
          create: (ctx) => Teachers(null,null,null,[]),
          update: (ctx, auth, previousTeachers) => Teachers(
              auth.token,
              auth.userEmail,
              auth.userRole,
              previousTeachers == null ? [] : previousTeachers.teachers),
        ),
        ChangeNotifierProxyProvider<Auth, TeachersAvailability>(
          create: (ctx) => TeachersAvailability(null,null,null,[]),
          update: (ctx, auth, previousAvailability) => TeachersAvailability(
              auth.token,
              auth.userEmail,
              auth.userRole,
              previousAvailability == null ? [] : previousAvailability.availability),
        ),
        ChangeNotifierProxyProvider<Auth, Repetitions>(
          create: (ctx) => Repetitions(null,null,null,[]),
          update: (ctx, auth, previousRepetitions) => Repetitions(
              auth.token,
              auth.userEmail,
              auth.userRole,
              previousRepetitions == null ? [] : previousRepetitions.repetitions),
        ),
      ],
      //Matirial App rebuild when we call notifyListeners in Auth
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor:myColors.background,
              primarySwatch: myColors.primaryMatirial,
              fontFamily: 'Lato',
              colorScheme:
              ColorScheme.fromSwatch(primarySwatch: myColors.primaryMatirial)
                  .copyWith(secondary: myColors.secondary)
                  .copyWith(error: myColors.error),
            ),
            home: auth.isEntered
                ? CoursesOverviewScreen()
                : AuthScreen(),
            routes: {
              CourseTeachersScreen.routeName: (ctx) => CourseTeachersScreen(),
              TeacherAvailabilityScreen.routeName: (ctx) => TeacherAvailabilityScreen(),
              UserRepetitionsScreen.routeName: (ctx) => UserRepetitionsScreen(),
              AdminRepetitionsScreen.routeName: (ctx) => AdminRepetitionsScreen(),
            }),
      ),
    );
  }
}
