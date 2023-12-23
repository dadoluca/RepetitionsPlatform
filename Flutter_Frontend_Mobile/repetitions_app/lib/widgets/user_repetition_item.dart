import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repetitions_app/variables/my_colors.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

import '../providers/repetitions.dart';

class UserRepetitionItem extends StatelessWidget {
  final int repId;
  final String teacherName;
  final String teacherSurname;
  final String teacherImg;
  final String courseName;
  final String date;
  final int state;

  UserRepetitionItem(this.repId, this.teacherName, this.teacherSurname,
      this.teacherImg, this.courseName, this.date, this.state);


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
    String nextHour = "${_date.hour+1}:${_date.minute}"; // "15:00"

    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
        leading: Container(
          width: state == 0 ? MediaQuery.of(context).size.width * 0.33: MediaQuery.of(context).size.width * 0.26,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              state == 0 ?
              Container(
                width: 70,
                height: 55,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: myColors.primary,
                      width: 1.5,
                    )),
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day $month',
                        ),
                        Text(
                          '${hour.substring(0,2)} - ${nextHour.substring(0,2)}',
                        )
                      ],
                    )),
              )
              :
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: state != 2 ? myColors.primary :  Color(0xFF9F656D),
                      width: 1.5,
                    )),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: TextStyle(
                        color: state == 2 ? myColors.disabled : Colors.black,
                      ),
                    ),
                    Text(
                      '$month',
                      style: TextStyle(
                        color: state == 2 ? myColors.disabled : Colors.black,
                      ),
                    )
                  ],
                )),
              ),
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
              ),
            ],
          ),
        ),
        title: Text(
          '${courseName}',
          style: TextStyle(
            color: state == 2 ? myColors.disabled : Colors.black,
          ),
        ),
        subtitle: Text('${teacherName} ${teacherSurname}'),

        trailing: Container(
          width: MediaQuery.of(context).size.width * 0.26,
          child: state == 0
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.done_outline,
                        color: myColors.primary,
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Do you confirm?'),
                            content: Text(
                              'Did the lesson with ${teacherName} take place?'
                              /*'\n\n($day $month, from $hour to $nextHour)'*/,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('No')),
                              TextButton(
                                  onPressed: () async{
                                    Navigator.of(ctx).pop();
                                    try{
                                      await Provider.of<Repetitions>(context, listen: false).updateRepetition(repId,true);
                                      scaffold.hideCurrentSnackBar();
                                      scaffold.showSnackBar(const SnackBar(
                                        content: Text('Lesson confirmed!',textAlign: TextAlign.center),
                                        backgroundColor: myColors.tertiary,
                                      ));
                                    }catch(error){
                                      scaffold.hideCurrentSnackBar();
                                      scaffold.showSnackBar(const SnackBar(
                                        content: Text('Confirmation failed!',textAlign: TextAlign.center),
                                        backgroundColor: myColors.error,
                                      ));
                                    }


                                  },
                                  child: const Text('Yes')),
                            ],
                          ),
                        );
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content: Text(
                              'Do you want to cancel this reservation with ${teacherName}?'
                                  /*'\n\n($day $month, from $hour to $nextHour)'*/,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('No')),
                              TextButton(
                                  onPressed: () async{
                              Navigator.of(ctx).pop();
                              try{
                                await Provider.of<Repetitions>(context, listen: false).updateRepetition(repId,false);
                                scaffold.hideCurrentSnackBar();
                                scaffold.showSnackBar(const SnackBar(
                                  content: Text('Lesson canceled!',textAlign: TextAlign.center),
                                  backgroundColor: myColors.tertiary,
                                ));
                              }catch(error){
                                scaffold.hideCurrentSnackBar();
                                scaffold.showSnackBar(const SnackBar(
                                  content: Text('Deleting faild!',textAlign: TextAlign.center),
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
              : state == 1/*
                  ? Text(
                      'CONFIRMED',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold, color: myColors.tertiary),
                    )
                  : Text(
                      'DELETED',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: myColors.disabled),
                    ),*/
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
                color:  Color(0xFF9F656D),
              ),
            ],
          ),
        ));
  }
}
