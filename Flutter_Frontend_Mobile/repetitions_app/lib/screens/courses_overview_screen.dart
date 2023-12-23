import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repetitions_app/widgets/courses_grid.dart';

import '../widgets/app_drawer.dart';
import '/providers/courses.dart';
import '../providers/auth.dart';

class CoursesOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isAuth = Provider.of<Auth>(context, listen: true).isAuth;

    return Scaffold(
      appBar: AppBar(title: const Text('Courses'), actions: <Widget>[
        IconButton(
          icon: Icon(_isAuth ? Icons.verified : Icons.login),
          tooltip: _isAuth ? 'Logged' : 'Login',
          onPressed: () {
            if(!_isAuth) {
              Navigator.of(context)
                  .pushReplacementNamed('/'); //mostriamo la home screen
              Provider.of<Auth>(context, listen: false).logout();
            }
          },
        ),
      ]),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Courses>(context, listen: false).fetchAndSetCourses(),
        builder: (ctx, dataSnapshot) {
          //is loading..
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapshot.error != null) {
            //error handling
            return const Center(
              child: Text('An error occurred!'),
            );
          } else {
            return CoursesGrid();
          }
        },
      ),
    );
  }
}
