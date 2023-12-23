import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repetitions_app/variables/my_colors.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

import '../providers/repetitions.dart';

class AdminRepetitionItem extends StatelessWidget {
  final int repId;
  final String teacherName;
  final String teacherSurname;
  final String teacherImg;
  final String courseName;
  final String userEmail;
  final String date;
  final int state;

  AdminRepetitionItem(this.repId, this.teacherName, this.teacherSurname,
      this.teacherImg, this.courseName, this.userEmail, this.date, this.state);

  Future<Uint8List> _getImage() async {
    Uri url = Uri.parse(teacherImg);
    final response = await http.get(url);
    final image = img.decodeImage(response.bodyBytes);
    img.grayscale(image);
    return img.encodePng(image);
  }

  @override
  Widget build(BuildContext context) {
    DateTime _date = DateTime.parse(date);
    String day = DateFormat.d().format(_date); // "13"
    String month = DateFormat.MMM().format(_date); // "FEB
    String hour = "${_date.hour}:${_date.minute}"; // "14:00"
    String nextHour = "${_date.hour + 1}:${_date.minute}"; // "15:00"

    Provider.of<Repetitions>(context, listen: true);

    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
        leading: Container(
          width: MediaQuery.of(context).size.width * 0.20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 70,
                height: 55,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: state != 2 ? myColors.primary : Color(0xFFAB2D41),
                      width: 1.5,
                    )),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day $month',
                      style: TextStyle(
                        color: state == 2 ? myColors.disabled : Colors.black,
                      ),
                    ),
                    Text(
                      '${hour.substring(0,2)} - ${nextHour.substring(0,2)}',
                      style: TextStyle(
                        color: state == 2 ? myColors.disabled : Colors.black,
                      ),
                    )
                  ],
                )),
              ),
/*
              CircleAvatar(
                backgroundImage: NetworkImage(teacherImg),
                child: state == 2
                    ? FutureBuilder<Uint8List>(
                        future: _getImage(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Uint8List> snapshot) {
                          if (snapshot.hasData) {
                            return ClipOval(
                              child: Image.memory(
                                snapshot.data,
                                fit: BoxFit.fill,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    : Text(''),
              ),*/
            ],
          ),
        ),
        title: Text(
          '${teacherName} ${teacherSurname}\n$courseName',
          style: TextStyle(
            color: state == 2 ? myColors.disabled : Colors.black,
          ),
        ),
        subtitle: Text('user: $userEmail'),
        trailing: Container(
          width: state == 0 ? MediaQuery.of(context).size.width * 0.13 : MediaQuery.of(context).size.width * 0.18,
          child: state == 0
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        //showDialog inserito io
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content: Text(
                              'Do you want to cancel this reservation with ${teacherName}?'
                              '\n\n($day $month, from $hour to $nextHour)',
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('No')),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.of(ctx).pop();
                                    try {
                                      await Provider.of<Repetitions>(context,
                                              listen: false)
                                          .updateRepetition(repId, false);
                                      scaffold.hideCurrentSnackBar();
                                      scaffold.showSnackBar(const SnackBar(
                                        content: Text('Lesson canceled!',
                                            textAlign: TextAlign.center),
                                        backgroundColor: myColors.tertiary,
                                      ));
                                    } catch (error) {
                                      scaffold.hideCurrentSnackBar();
                                      scaffold.showSnackBar(const SnackBar(
                                        content: Text('Deleting faild!',
                                            textAlign: TextAlign.center),
                                        backgroundColor: myColors.error,
                                      ));
                                    }
                                  },
                                  child: const Text('Yes')),
                            ],
                          ),
                        );
                      },
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                )
              : state == 1
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text(
                          'CONFIRMED',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: myColors.tertiary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.check,
                          color: myColors.tertiary,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text(
                          'DELETED',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: myColors.disabled,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.cancel,
                          color:  Color(0xFFAB2D41),
                        ),
                      ],
                    ),
        ));
  }
}
