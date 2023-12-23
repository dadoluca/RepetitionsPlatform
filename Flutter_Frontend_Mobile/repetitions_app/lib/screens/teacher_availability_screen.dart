import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repetitions_app/models/availability.dart';
import 'package:repetitions_app/variables/my_colors.dart';

import '../providers/auth.dart';
import '../providers/availability.dart';
import '../providers/teachers.dart';
import '../widgets/availability_table.dart';

class TeacherAvailabilityScreen extends StatelessWidget {
  static const routeName = '/availability';

  Future<void> _refreshAvailability(BuildContext context, int teacherId) async {
    await Provider.of<TeachersAvailability>(context, listen: false)
        .fetchAndSetTeacherAvailability(teacherId);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    final courseId = arguments['courseId'] as int;
    final courseName = arguments['courseName'] as String;
    final teacherId = arguments['teacherId'] as int;
    final teacherName = arguments['teacherName'] as String;
    final teacherSurname = arguments['teacherSurname'] as String;
    final teacherImageUrl = arguments['teacherImageUrl'] as String;
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    bool _isAuth = Provider.of<Auth>(context, listen: true).isAuth;

    return Scaffold(
      appBar: AppBar(
        title: Text('$teacherName\'s  availability'),
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(6.0),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(teacherImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '$teacherName $teacherSurname',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '$courseName',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Spacer(),
                const SizedBox(width: 50,),
                const Text(
                  'Book a lesson!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: myColors.secondary,
                  child: IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      _refreshIndicatorKey.currentState?.show();
                    },
                  ),
                ),
                SizedBox(width: 10,)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: _refreshAvailability(context, teacherId),
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
                  return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    strokeWidth: 4.0,
                    backgroundColor: myColors.secondary,
                    color: Colors.white,
                    //onRefresh: () => _refreshAvailability(context, teacherId),
                    onRefresh: () async {
                      //ritardo già presente per la chiamata e accentuato a scopo illustrativo
                      return Future<void>.delayed(const Duration(seconds: 2),
                          () {
                        _refreshAvailability(context, teacherId);
                      });
                    },
                    child: Consumer<TeachersAvailability>(
                      builder: (ctx, teachersData, _) =>
                          AvailabilityTable(courseId, teacherId),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),/*
      floatingActionButton: FloatingActionButton /*.extended*/ (
        tooltip: 'Reload the page!',
        backgroundColor: myColors.secondary,
        onPressed: () {
          _refreshIndicatorKey.currentState?.show();
        },
        child: const Icon(
          Icons.refresh,
          size: 23,
        ),
        //icon: const Icon(Icons.refresh,size: 23,),
        //label: const Text('Refresh',style: TextStyle(fontSize: 11,color: Colors.black, fontWeight: FontWeight.bold),),
      ),*/
    );
  }
}
