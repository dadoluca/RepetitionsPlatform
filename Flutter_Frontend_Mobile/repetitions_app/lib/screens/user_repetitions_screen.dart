import 'package:flutter/material.dart';
import 'package:repetitions_app/models/repetition.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/repetitions.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_repetition_item.dart';

class UserRepetitionsScreen extends StatelessWidget {
  static const routeName = '/userRepetition';

  Future<void> _refreshRepetitions(BuildContext context) async {
    await Provider.of<Repetitions>(context, listen: false)
        .fetchUserRepetitions();
  }

  @override
  Widget build(BuildContext context) {
    bool _isAuth = Provider.of<Auth>(context, listen: true).isAuth;

    return Scaffold(
      appBar: AppBar(
        title: Text('My  Lessons'),
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
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Repetitions>(context, listen: false)
            .fetchUserRepetitions(),
        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? const  Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: () => _refreshRepetitions(context),
          child: Consumer<Repetitions>(
            builder: (ctx, repetitionsData, _) => Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: repetitionsData.repetitions.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    UserRepetitionItem(
                      repetitionsData.repetitions[i].id,
                      repetitionsData.repetitions[i].teacherName,
                      repetitionsData.repetitions[i].teacherSurname,
                      repetitionsData.repetitions[i].teacherImg,
                      repetitionsData.repetitions[i].courseName,
                      repetitionsData.repetitions[i].startDate,
                      repetitionsData.repetitions[i].state,
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
