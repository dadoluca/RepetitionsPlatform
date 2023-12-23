import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../variables/server_connection.dart';

class Auth with ChangeNotifier {

  bool _isEntered = false;
  int _userRole; //0 admin, 1 user
  String _userEmail;
  String _token;

  bool get isEntered {
    return _isEntered;
  }

  int get userRole{
    return _userRole;
  }

  bool get isAuth{
    return _token!=null;
  }

  String get userEmail {
    return _userEmail;
  }

  String get token{
    return _token;
  }

    void guestLogin(){
    _isEntered = true;
    _userRole = null;
    notifyListeners();
  }

  Future<void> authenticate(String email, String password) async{
    final url = Uri.parse(
        '${ServerConnection.url}'
            '/autentication?username=$email&password=$password');
    try{
      final response = await http.post(
        url,
        /*body: json.encode({
            'username': email,
            'password': password,
          },),*/
      );
      final responseData = json.decode(response.body);
      print("response from server: $responseData");

      if(responseData['errorMsg']!=null){
        print(responseData['errorMsg']);
        throw HttpException(responseData['errorMsg']);
      }
      else{
        _isEntered = true;
        //final user = json.decode(responseData['utente']);
        //int role = user['ruolo'];
        _userEmail = responseData['username'];
        _token = responseData['sessionId'];
        _userRole = responseData['ruolo'];
        print("$_userEmail role: $_userRole");
        notifyListeners();
      }
    }catch(error){
      print("Error from server: $error");
      rethrow;
    }
  }


  //se non uso shared preferences posso lasciarlo void
  void logout() {
    _isEntered = false;
    _userRole = null;
    _userEmail = null;
    _token = null;
    notifyListeners();
  }

}