import 'package:flutter/material.dart';
import 'package:repetitions_app/variables/my_colors.dart';

import '../models/availability.dart' as availabilityModel;
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/availability.dart';

class AvailabilityItem extends StatelessWidget {
  final availabilityModel.Availability availability;
  final int courseId;
  final int teacherId;
  const AvailabilityItem(this.availability,this.courseId,this.teacherId);

  @override
  Widget build(BuildContext context) {
    bool _isAuth = Provider.of<Auth>(context, listen: false).isAuth;
    bool _isAdmin = Provider.of<Auth>(context, listen: false).userRole == 0 ? true : false;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 108,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              '${availability.startHour.substring(0, 2)} - ${availability.endHour.substring(0, 2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            !availability.booked
                ? Column(
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    _isAdmin ?
                    Column(
                      children: [
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(
                          Icons.add_task,
                          color: Colors.black,
                        ),
                        const Text(
                          'Bookable',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                    :
                    Column(
                      children: [
                        const  Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        ElevatedButton/*.icon*/(
                            /*icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),*/
                            //tooltip: 'Book this hour!',
                             onPressed: () async {
                              //chiamata al provider - insert repetition...
                              if (_isAuth) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                bool succed = await Provider.of<TeachersAvailability>(context, listen: false).bookRepetition(availability.id, courseId, teacherId);
                                if(succed){
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text(
                                      'Lesson successfully booked!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    duration: Duration(seconds: 5),
                                    /*action: SnackBarAction(
                                        label: 'UNDO',
                                        textColor: Colors.black,
                                        onPressed: () {
                                          //......
                                          //......
                                        }),*/
                                    backgroundColor: myColors.success,
                                  ));
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text(
                                      'Something went wrong! Try again.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    duration: Duration(seconds: 5),
                                    backgroundColor: myColors.error,
                                  ));
                                }
                              } else {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    'You are not logged in! Login first.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  duration: Duration(seconds: 4),
                                  backgroundColor: myColors.warning,
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColors.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text(
                              'Book',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      availability.bookedByUser
                        ? const SizedBox(
                          height: 16,
                        ): const SizedBox(
                        height: 6,
                      ),
                      availability.bookedByUser
                          ? const Icon(Icons.assignment_turned_in, color: Colors.black)
                          : const Icon(Icons.not_interested,color: Color(0xFF72172e), /*color:  Color(0xFF6C6B6C)*/),
                      availability.bookedByUser
                        ? const Text(
                        ' Mine !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      )
                          :
                      const Text(
                        'Already\nbooked',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF72172e),
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
