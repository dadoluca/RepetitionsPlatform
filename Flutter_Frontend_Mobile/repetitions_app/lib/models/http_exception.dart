import 'package:flutter/material.dart';

//My own HttpException class
class HttpException implements Exception{
  final String message;

  HttpException(this.message);

  @override
  String toString(){
    //return super.toString();//Instance of HttpExceprion
    return message;
  }

}