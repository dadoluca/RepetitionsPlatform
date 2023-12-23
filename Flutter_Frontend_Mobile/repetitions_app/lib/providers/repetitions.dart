import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:repetitions_app/models/repetition.dart';

import '../variables/server_connection.dart';
import '../models/http_exception.dart';
import '../models/availability.dart';

class Repetitions with ChangeNotifier {
  List<Repetition> _repetitions = [];
  List<Repetition> _activeRepetitionsList = [];
  List<Repetition> _pastRepetitionsList = [];

  final String authToken;
  final String userEmail;
  final int userRole; // 0 admin //1 user

  Repetitions(this.authToken, this.userEmail, this.userRole, this._repetitions);

  //{"availability":"[{\"idDisponibilita\":88,\"dataInizio\":\"2023-02-13 14:00:00.0\",\"dataFine\":\"2023-02-13 15:00:00.0\",\"idDocente\":0},{\"idDisponibilita\":89,\"dataInizio\":\"2023-02-13 15:00:00.0\",\"dataFine\":\"2023-02-13 16:00:00.0\",\"idDocente\":0},{\"idDisponibilita\":90,\"dataInizio\":\"2023-02-13 16:00:00.0\",\"dataFine\":\"2023-02-13 17:00:00.0\",\"idDocente\":0},{\"idDisponibilita\":91,\"dataInizio\":\"2023-02-13 17:00:00.0\",\"dataFine\":\"2023-02-13 18:00:00.0\",\"idDocente\":0},{\"idDisponibilita\":92,\"dataInizio\":\"2023-02-13 18:00:00.0\",\"dataFine\":\"2023-02-13 19:00:00.0\",\"idDocente\":0},{\"idDisponibilita\":93,\"dataInizio\":\"2023
  List<Repetition> get repetitions {
    return [..._repetitions];
  }

  List<Repetition> get activeRep {
    return [..._activeRepetitionsList];
  }

  List<Repetition> get pastRep {
    return [..._pastRepetitionsList];
  }

  Future<List<Repetition>> fetchUserRepetitions([String teacherId = '']) async {
    _repetitions = [];
    _activeRepetitionsList = [];
    _pastRepetitionsList = [];
    var parameter;
    //If user is Admin i fetch all the repetitions
    if (userRole == 0) {
      parameter = 'action=admin';
    } else {
      parameter = 'userId=$userEmail';
    }

    final url = Uri.parse('${ServerConnection.url}/repetitions' +
        ';jsessionid=$authToken?$parameter');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final extractedRepetitions =
          json.decode(extractedData['repetitions']) as List<dynamic>;
      if (extractedRepetitions == null) return null;

      //print(extractedData);
      for (var repetitionsData in extractedRepetitions) {
        Repetition newRep = Repetition(
          id: repetitionsData['idRipetizione'],
          availabilityId: repetitionsData['idDisponibilita'],
          teacherName: repetitionsData['nomeDocente'],
          teacherSurname: repetitionsData['cognomeDocente'],
          teacherImg: repetitionsData['imageUrlDocente'],
          courseName: repetitionsData['nomeCorso'],
          startDate: repetitionsData['dataInizio'],
          endDate: repetitionsData['dataFine'],
          state: repetitionsData['stato'],
          userId: repetitionsData['username'],
        );
        if (teacherId == '' ||
            repetitionsData['idDocente'].toString() ==
                teacherId) {
          if (newRep.state == 0) {
            _activeRepetitionsList.add(newRep);
          } else {
            _pastRepetitionsList.add(newRep);
          }
        }
      }
      //ordino quelle attive dalla più vicina alla meno
      _activeRepetitionsList.sort((a, b) => a.startDate.compareTo(b.startDate));
      //ordino quelle passate dalla più recente alla meno
      _pastRepetitionsList.sort((a, b) => b.startDate.compareTo(a.startDate));

      //aggiungo prima la lista di quelle attive, poi la lista di quelle passate
      _repetitions.addAll(_activeRepetitionsList);
      _repetitions.addAll(_pastRepetitionsList);
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException(
          'Could not fetch repetitions. $error'); //il resto de codice non viene eseguito
    }
  }

  Future<void> updateRepetition(int idRep, bool confirm) async {
    final repIndex = _repetitions.indexWhere((rep) => rep.id == idRep);
    if (repIndex >= 0) {
      final state = confirm ? 'confirm' : 'delete';
      final parameter = 'idRipetizione=$idRep&action=$state';
      final url = Uri.parse('${ServerConnection.url}/repetitions' +
          ';jsessionid=$authToken?$parameter');
      final response = http.post(url, body: json.encode({}));
      if (confirm) {
        _repetitions[repIndex].state = 1;
      } else {
        _repetitions[repIndex].state = 2;
      }
      notifyListeners(); /*
      Future.delayed(const Duration(milliseconds: 200), () {
        fetchUserRepetitions();
      });*/
    } else {
      print('...');
    }
  }
}
