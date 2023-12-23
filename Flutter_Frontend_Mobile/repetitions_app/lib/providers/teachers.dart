import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/teacher.dart';
import '../variables/server_connection.dart';
import '../models/http_exception.dart';

class Teachers with ChangeNotifier {
   List<Teacher> _teachers = [/*
    Teacher(
        id: 0,
        name: 'Luca',
        surname: 'Dadone',
        prize: 15,
        sex: 'Man',
        imageUrl:
            'https://media.licdn.com/dms/image/D4E03AQH3qIBVvRENCQ/profile-displayphoto-shrink_800_800/0/1665594879330?e=1676505600&v=beta&t=4CoCqgcolg80OOjNaOzuT02timMQ_TWXdWGW5KIThmo'),
    Teacher(
        id: 1,
        name: 'Davide',
        surname: 'Benotto',
        prize: 12,
        sex: 'Man',
        imageUrl:
            'https://media-exp1.licdn.com/dms/image/C4D03AQETlkVTfqG4sw/profile-displayphoto-shrink_200_200/0/1607097833396?e=1675900800&v=beta&t=8wjqc0pF4Vy73yRarHy-UXMo7CVj8UaPYz-4PVKHtC0'),
     Teacher(
         id: 2,
         name: 'Gioele',
         surname: 'Mola',
         prize: 4,
         sex: 'Man',
         imageUrl:
         'https://media-exp1.licdn.com/dms/image/C4E03AQGnD0rxoM2qjQ/profile-displayphoto-shrink_800_800/0/1614786062352?e=2147483647&v=beta&t=NobWcteZ5bcXWlL4VMjRAxAwaOcPA59iy8_Cp2ve51M'),
   */];
//   "idDocente":0,
//   "email":"luca.dadone01@gmail.com",
//   "nome":"Luca",
//   "cognome":"Dadone",
//   "sesso":"uomo",
//   "eta":21,
//   "formazione":"Laurea Magistrale in Informatica",
//   "prezzoH":20,
//   "imageUrl":"https://media.licdn.com/dms/image/D4E03AQH3qIBVvRENCQ/profile-displayphoto-shrink_800_800/0/1665594879330?e\u003d2147483647\u0026v\u003dbeta\u0026t\u003dmQFaFzeNPC10tzbZ9PitD0gEk4kJQCBEtdc7A7R3DKs",
//   "imageUrlUniversity":"https://scontent.ffco2-1.fna.fbcdn.net/v/t39.30808-6/302139900_571605517951210_6817004685332558320_n.jpg?stp\u003ddst-jpg_s960x960\u0026_nc_cat\u003d103\u0026ccb\u003d1-7\u0026_nc_sid\u003de3f864\u0026_nc_ohc\u003dCBfkjvi47wAAX8uJSeo\u0026_nc_ht\u003dscontent.ffco2-1.fna\u0026oh\u003d00_AfCoH8FPUUAMbIQMQLPSthpnHPSyYorqNv5qsjb2DpmPDA\u0026oe\u003d63BCA7F9"}

  List<Teacher> get teachers {
    return [..._teachers];
  }

  final String authToken;
  final String userEmail;
  final int userRole;// 0 admin //1 user

  Teachers(this.authToken, this.userEmail, this.userRole, this._teachers);


  bool isEmpty() {
    return _teachers.isEmpty;
  }

 Future<void> fetchAndSetTeachers([int courseId = -1]) async {
    final filterString = courseId != -1 ? 'courseId=$courseId': '';

    final url = Uri.parse('${ServerConnection.url}/teachers'
        +';jsessionid=$authToken?$filterString');

    try {
      final response = await http.get(url);
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final extractedData = json.decode(response.body) as List<dynamic>;
      if (extractedData == null) return;
      final List<Teacher> loadedTeachers = [];
      //print(extractedData);
      for (var teacherData in extractedData) {
        loadedTeachers.add(Teacher(
          id: teacherData['idDocente'],
          email: teacherData['email'],
          name: teacherData['nome'],
          surname: teacherData['cognome'],
          sex: teacherData['sesso'],
          prize: teacherData['prezzoH'],
          age: teacherData['eta'],
          degree: teacherData['formazione'],
          imageUrl: teacherData['imageUrl'],
          imageUrlUniversity: teacherData['imageUrlUniversity'],
        ));
      }
      loadedTeachers.sort((a, b) => a.surname.compareTo(b.surname));
      _teachers = loadedTeachers;
      //Future.delayed(const Duration(milliseconds: 100), () {
        notifyListeners();
      //});

    } catch (error) {
      //print(error);
      throw HttpException('Could not fetch teachers.'); //il resto de codice non viene eseguito

      rethrow;
    }
  }



}
