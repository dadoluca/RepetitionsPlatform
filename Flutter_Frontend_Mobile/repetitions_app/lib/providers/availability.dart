import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:repetitions_app/models/repetition.dart';

import '../variables/server_connection.dart';
import '../models/http_exception.dart';
import '../models/availability.dart';

class TeachersAvailability with ChangeNotifier {
  List<Availability> _availability = [
    Availability(
        ///example
        id: 88,
        startDate: '2023-02-13 14:00:00.0',
        endDate: '2023-02-13 15:00:00.0',
        teacherId: 0,
        day: 0,
        startHour: "14:00",
        endHour: "15:00",
        booked: false),
  ];

  final String authToken;
  final String userEmail;
  final int userRole; // 0 admin //1 user

  TeachersAvailability(
      this.authToken, this.userEmail, this.userRole, this._availability);

  //{"availability":"[{\"idDisponibilita\":88,\"dataInizio\":\"2023-02-13 14:00:00.0\",\"dataFine\":\"2023-02-13 15:00:00.0\",\"idDocente\":0},{\"idDisponibilita\":89,\"dataInizio\":\"2023-02-13 15:00:00.0\",\"dataFine\":\"2023-02-13 16:00:00.0\",\"idDocente\":0},{\"idDisponibilita\":90,\"dataInizio\":\"2023-02-13 16:00:00.0\",\"dataFine\":\"2023-02-13 17:00:00.0\",\"idDocente\":0},{\"idDisponibilita\":91,\"dataInizio\":\"2023-02-13 17:00:00.0\",\"dataFine\":\"2023-02-13 18:00:00.0\",\"idDocente\":0},{\"idDisponibilita\":92,\"dataInizio\":\"2023-02-13 18:00:00.0\",\"dataFine\":\"2023-02-13 19:00:00.0\",\"idDocente\":0},{\"idDisponibilita\":93,\"dataInizio\":\"2023
  List<Availability> get availability {
    return [..._availability];
  }

  Future<void> fetchAndSetTeacherAvailability(int teacherId) async {
    final filterString = teacherId != -1 ? 'teacherId=$teacherId' : '';

    final url = Uri.parse('${ServerConnection.url}/availability' +
        ';jsessionid=$authToken?$filterString');

    final List<Repetition> repetitionsList = await fetchTeacherRepetitions(teacherId);

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final extractedAvailability =
          json.decode(extractedData['availability']) as List<dynamic>;
      if (extractedAvailability == null) return;
      final List<Availability> loadedAvailabilityList = [];

      for (var availabilityData in extractedAvailability) {
        //'2023-02-13 15:00:00.0'
        // Parse the date string into a DateTime object
        DateTime date = DateTime.parse(availabilityData['dataInizio']);
        // Extract the day of the week (0 to 6)
        int dayOfWeek = int.parse(date.weekday.toString()) - 1;
        String startDateTime =
            date.hour.toString() + ':' + date.minute.toString();

        date = DateTime.parse(availabilityData['dataFine']);
        String endDateTime =
            date.hour.toString() + ':' + date.minute.toString();

        bool booked=false;
        bool bookedByUser=false;
        for (var item in repetitionsList) {
          if (item.availabilityId == availabilityData['idDisponibilita'])
            {
              booked=true;
              if(item.userId==userEmail) {
                bookedByUser=true;
              }
            }
        }
        loadedAvailabilityList.add(Availability(
          id: availabilityData['idDisponibilita'],
          startDate: availabilityData['dataInizio'],
          endDate: availabilityData['dataFine'],
          teacherId: availabilityData['iDDocente'],
          day: dayOfWeek,
          startHour: startDateTime,
          endHour: endDateTime,
          booked: booked,
          bookedByUser: bookedByUser,
        ));
      }
      _availability = loadedAvailabilityList;
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException(
          'Could not fetch availability. $error'); //il resto de codice non viene eseguito
      rethrow;
    }
  }

  Future<List<Repetition>> fetchTeacherRepetitions(int teacherId) async {
    final filterString = teacherId != -1 ? 'teacherId=$teacherId' : '';

    final url = Uri.parse('${ServerConnection.url}/repetitions' +
        ';jsessionid=$authToken?$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final extractedRepetitions =
          json.decode(extractedData['repetitions']) as List<dynamic>;
      if (extractedRepetitions == null) return null;
      final List<Repetition> loadedRepetitionsList = [];
      //print(extractedData);
      for (var repetitionsData in extractedRepetitions) {
        loadedRepetitionsList.add(Repetition(id: repetitionsData['idRipetizione'],
            courseId: repetitionsData['idCorso'],
            userId: repetitionsData['idUtente'],
            availabilityId: repetitionsData['idDisponibilita'],
            teacherId: repetitionsData['idDocente'],
        ));
      }
      return loadedRepetitionsList;
    } catch (error) {
      print(error);
      throw HttpException(
          'Could not fetch repetitions. $error'); //il resto de codice non viene eseguito
    }
  }

  List<Availability> filterDay(int day) {
    List<Availability> list = [];
    for (var item in _availability) {
      if (item.day == day) list.add(item);
    }
    return list;
  }

  Future<bool> bookRepetition(int availabilityId, int courseId, int teacherId) async {
    print(availabilityId);
    final parameters = 'action=insert&idUtente=$userEmail&idCorso=$courseId&idDisponibilita=$availabilityId';

    final url = Uri.parse('${ServerConnection.url}/repetitions' +
        ';jsessionid=$authToken?$parameters');
    try {
      final response = await http.post(url,
          body: json.encode({
            'idUtente': userEmail,
            'idCorso': courseId,
            'idDisponibilita': availabilityId,
          }));
      if(json.decode(response.body)['status']=='OK'){
        final availabilityIndex = availability.indexWhere((a) => a.id == availabilityId);
        availability[availabilityIndex].booked = true;
        availability[availabilityIndex].bookedByUser = true;
        notifyListeners();
        return true;
      }
      else{
        return false;
      }

    } catch (error) {
      print(error);
      return false;
    }
  }
}
