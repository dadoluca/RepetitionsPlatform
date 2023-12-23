import 'package:flutter/material.dart';
class myColors{

  /* static const Color secondaryMatirial =  MaterialColor(0xff8EEEB3FF/*0xffa5ecc0*/, _myMatirialLightGreen);
   static const Color primaryMatirial =  MaterialColor(0xffc44dff/*0xff13412a*/, _myMatirialPurple);
   static const Color secondary = Color(0xff34cc8a);
   static const Color lightSecondary = Color(0xfdb1ffd2);
   static const Color primary = Color(0xffd93ed6);
   static const Color tertiary = Color(0xff750a94);//.fromARGB(1000, 218, 96, 239);
   static const Color error = Color(0xFFB71531);
*/
  static const Color secondaryMatirial =  MaterialColor(0xff3bd7c5/*0xffa5ecc0*/, _myMatirialLightGreen);
  static const Color primaryMatirial =  MaterialColor(0xff2ba170/*0xff13412a*/, _myMatirialPurple);
  static const Color secondary = Color(0xffa8b930);
  static const Color lightSecondary = Color(0xfff7dfff);
  static const Color primary = Color(0xff35c48b);//0xff2dce89
  static const Color tertiary = Color(0xff026243);//.fromARGB(1000, 218, 96, 239);
  static const Color error = Color(0xFFE1475F);
  static const Color success = Color(0xFF3287FF);
  static const Color warning = Color(0xFFB27A00);
  static const Color background = Color(0xFFF6F9FF);
  static const Color disabled = Color(0xEC686869);


  static const Map<int, Color> _myMatirialLightGreen =
  {
    50:Color.fromRGBO(175,255,218, .1),
    100:Color.fromRGBO(175,255,218, .2),
    200:Color.fromRGBO(175,255,218, .3),
    300:Color.fromRGBO(175,255,218, .4),
    400:Color.fromRGBO(175,255,218, .5),
    500:Color.fromRGBO(175,255,218, .6),
    600:Color.fromRGBO(175,255,218, .7),
    700:Color.fromRGBO(175,255,218, .8),
    800:Color.fromRGBO(175,255,218, .9),
    900:Color.fromRGBO(175,255,218, 1),
  };

   static const purple_R = 204;//43;
   static const purple_G = 102;//114;
   static const purple_B = 255;//81;
   static const Map<int, Color> _myMatirialPurple =
   {
     50:Color.fromRGBO(purple_R,purple_G,purple_B, .1),
     100:Color.fromRGBO(purple_R,purple_G,purple_B, .2),
     200:Color.fromRGBO(purple_R,purple_G,purple_B, .3),
     300:Color.fromRGBO(purple_R,purple_G,purple_B, .4),
     400:Color.fromRGBO(purple_R,purple_G,purple_B, .5),
     500:Color.fromRGBO(purple_R,purple_G,purple_B, .6),
     600:Color.fromRGBO(purple_R,purple_G,purple_B, .7),
     700:Color.fromRGBO(purple_R,purple_G,purple_B, .8),
     800:Color.fromRGBO(purple_R+100,purple_G+100,purple_B, .9),
     900:Color.fromRGBO(purple_R+100,purple_G+100,purple_B, 1),
   };
 }

