import 'package:flutter/material.dart';
import 'package:repetitions_app/models/repetition.dart';
import 'package:provider/provider.dart';
import 'package:repetitions_app/variables/my_colors.dart';

import '../models/teacher.dart';
import '../providers/auth.dart';
import '../providers/repetitions.dart';
import '../providers/teachers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/admin_repetition_item.dart';

class AdminRepetitionsScreen extends StatefulWidget {
  static const routeName = '/adminRepetitions';

  @override
  State<AdminRepetitionsScreen> createState() => _AdminRepetitionsScreenState();
}

class _AdminRepetitionsScreenState extends State<AdminRepetitionsScreen> {
  Future<void> _refreshRepetitions(BuildContext context) async {
    _selectedValue != null
        ? await Provider.of<Repetitions>(context, listen: false)
            .fetchUserRepetitions(_selectedValue)
        : await Provider.of<Repetitions>(context, listen: false)
            .fetchUserRepetitions();
  }

  String _selectedValue;

  @override
  Widget build(BuildContext context) {
    bool _isAuth = Provider.of<Auth>(context, listen: true).isAuth;

    return Scaffold(
      appBar: AppBar(title: const Text('Lessons'), actions: <Widget>[
        IconButton(
          icon: Icon(_isAuth ? Icons.verified : Icons.login),
          tooltip: _isAuth ? 'Logged' : 'Login',
          onPressed: () {
            if (!_isAuth) {
              Navigator.of(context)
                  .pushReplacementNamed('/'); //mostriamo la home screen
              Provider.of<Auth>(context, listen: false).logout();
            }
          },
        ),
      ]),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshRepetitions(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshRepetitions(context),
                child: Consumer<Repetitions>(
                  builder: (ctx, repetitionsData, _) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: Provider.of<Teachers>(context, listen: false)
                              .fetchAndSetTeachers(),
                          builder: (ctx, snapshot) => (DropdownButton<String>(
                            borderRadius: BorderRadius.circular(8.0),
                            hint: Text(
                              '     filter by teacher',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            value: _selectedValue,
                            items: Provider.of<Teachers>(context, listen: false)
                                .teachers
                                .map((Teacher teacher) {
                              return DropdownMenuItem<String>(
                                value: teacher.id.toString(),
                                child:
                                    Text('${teacher.surname} ${teacher.name}'),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              print(newValue);
                              setState(() {
                                _selectedValue = newValue;
                              });
                              // Provider.of<Repetitions>(context, listen: false).fetchUserRepetitions(newValue);
                            },
                          )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        repetitionsData.activeRep.isNotEmpty
                            ? Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Active',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            repetitionsData.activeRep.length,
                                        itemBuilder: (_, i) => Column(
                                          children: [
                                            AdminRepetitionItem(
                                              repetitionsData.activeRep[i].id,
                                              repetitionsData
                                                  .activeRep[i].teacherName,
                                              repetitionsData
                                                  .activeRep[i].teacherSurname,
                                              repetitionsData
                                                  .activeRep[i].teacherImg,
                                              repetitionsData
                                                  .activeRep[i].courseName,
                                              repetitionsData
                                                  .activeRep[i].userId,
                                              repetitionsData
                                                  .activeRep[i].startDate,
                                              repetitionsData
                                                  .activeRep[i].state,
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Text(
                                'No active repetitions.',
                                style: TextStyle(fontSize: 20),
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Divider(),
                        repetitionsData.pastRep.isNotEmpty
                            ? Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Past',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            repetitionsData.pastRep.length,
                                        itemBuilder: (_, i) => Column(
                                          children: [
                                            AdminRepetitionItem(
                                              repetitionsData.pastRep[i].id,
                                              repetitionsData
                                                  .pastRep[i].teacherName,
                                              repetitionsData
                                                  .pastRep[i].teacherSurname,
                                              repetitionsData
                                                  .pastRep[i].teacherImg,
                                              repetitionsData
                                                  .pastRep[i].courseName,
                                              repetitionsData.pastRep[i].userId,
                                              repetitionsData
                                                  .pastRep[i].startDate,
                                              repetitionsData.pastRep[i].state,
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Text(
                                'No past repetitions.',
                                style: TextStyle(fontSize: 20),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
