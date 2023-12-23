import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repetitions_app/widgets/day_column.dart';
import '../providers/availability.dart';
import 'availability_item.dart';
import '../variables/my_colors.dart';

class AvailabilityTable extends StatelessWidget {
  final int courseId;
  final int teacherId;
  const AvailabilityTable(this.courseId, this.teacherId);

  @override
  Widget build(BuildContext context) {
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    PageController _pageController = PageController(viewportFraction: 0.33, initialPage: 1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.63,
        child: Stack(
          children: [
            PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: days.length,
              controller: _pageController,
              itemBuilder: (ctx, i) => DayColumn(days[i],
                  Provider.of<TeachersAvailability>(context, listen: false).filterDay(i),courseId,teacherId,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_left, color: Colors.black, size: 36),
                onPressed: () {
                  _pageController.previousPage(duration: Duration(milliseconds: 400), curve: Curves.ease);
                },
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.arrow_right, color: Colors.black, size: 36),
                onPressed: () {
                  _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.ease);
                },
              ),
            ),
          ],
        ),
      ),
    );


  }
}


