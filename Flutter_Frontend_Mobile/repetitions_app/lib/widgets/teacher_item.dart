import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repetitions_app/screens/teacher_availability_screen.dart';
import 'package:repetitions_app/variables/my_colors.dart';
import '../models/teacher.dart';
import '../providers/teachers.dart';
import 'package:http/http.dart' as http;

class TeacherItem extends StatelessWidget {
  final Teacher teacher;
  final int courseId;
  final String courseName;

  const TeacherItem(this.courseId,this.courseName, this.teacher);

  Future<List<int>> _loadImage(String url) async {
    Uri u = Uri.parse(url);
    final response = await http.get(u);
    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    //final Teacher teacher = Provider.of<Teachers>(context, listen: false).findById(..);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          TeacherAvailabilityScreen.routeName,
          arguments: {
            'courseId': courseId,
            'courseName' : courseName,
            'teacherId': teacher.id,
            'teacherName' : teacher.name,
            'teacherSurname' : teacher.surname,
            'teacherImageUrl' : teacher.imageUrl,
          }
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child:  Column(
          children: [
            Stack(
              //Sovrappongo il testo all'immagine
              children: [
                //ClipRRect is a widget that force the child to stay in a specific form
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child:  FutureBuilder(
                    future: _loadImage(teacher.imageUrlUniversity),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return //FittedBox(
                          //fit: BoxFit.contain,
                          /*child: */
                          Image.memory(
                            snapshot.data,
                            width: double.infinity,
                            height: 230.0,
                            fit: BoxFit.cover,
                          // ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(teacher.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 7,
                  child: Container(
                    //width: 220,
                    decoration: BoxDecoration(
                      color: myColors.tertiary.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      '${teacher.name} ${teacher.surname}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.school_sharp),
                      const SizedBox(width: 20),
                      Expanded(child: Text('${teacher.degree}')),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.email),
                      const SizedBox(width: 20),
                      Text('${teacher.email}'),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_money),
                      const SizedBox(width: 6),
                      Text('${teacher.prize}', style: TextStyle(fontSize: 17),),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
