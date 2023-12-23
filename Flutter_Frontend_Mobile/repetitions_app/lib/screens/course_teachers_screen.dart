import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/teachers.dart';
import '../widgets/teacher_item.dart';

class CourseTeachersScreen extends StatelessWidget {
  static const routeName = '/teachers';

  Future<void> _refreshTeachers(BuildContext context, int courseId) async {
    //non vogliamo un listener quindi listen: false to avoid unnecessary widget rebuild
    await Provider.of<Teachers>(context, listen: false)
        .fetchAndSetTeachers(courseId);
  }

  @override
  Widget build(BuildContext context) {
    bool _isAuth = Provider.of<Auth>(context, listen: true).isAuth;
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    final courseId = arguments['courseId'] as int;
    final courseName = arguments['courseName'] as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('$courseName Teachers'),
          actions: <Widget>[
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
          ]
      ),
      body: FutureBuilder(
        future: _refreshTeachers(context, courseId),
        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: () => _refreshTeachers(context, courseId),
          child: Consumer<Teachers>(
            builder: (ctx, teachersData, _) => Padding(
              padding: const EdgeInsets.all(8),
              child:
              ListView.builder(
                itemCount: teachersData.teachers.length,
                itemBuilder: (_, i) => TeacherItem(
                            courseId,
                            courseName,
                            teachersData.teachers[i]
                          ),

              ),
            ),
          ),
        ),
      ),
    );
  }
}
