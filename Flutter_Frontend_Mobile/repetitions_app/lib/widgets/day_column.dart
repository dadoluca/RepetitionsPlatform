import 'package:flutter/material.dart';
import 'package:repetitions_app/widgets/availability_item.dart';
import '../models/availability.dart';
import '../variables/my_colors.dart';

class DayColumn extends StatelessWidget {
  final String day;
  final List<Availability> dayAvailabilityList;
  final int courseId;
  final int teacherId;

  const DayColumn(this.day, this.dayAvailabilityList,this.courseId, this.teacherId);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width * 0.30,
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [myColors.tertiary.withOpacity(0.8), myColors.primary.withOpacity(0.6)],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10),
            child: Center(
              child: Text(
                day.substring(0, 3).toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'Anton-Regular',
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dayAvailabilityList.length,
              itemBuilder: (context, i) {
                return Column(
                  children: <Widget>[
                    AvailabilityItem(dayAvailabilityList[i], courseId,teacherId),
                    const Divider(color: Colors.white, height: 3, indent: 25, endIndent: 25, thickness: 1.6),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
