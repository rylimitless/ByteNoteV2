import 'package:bytenote/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController{
  static ThemeController get to => Get.find();
  bool _isDarkMode = false;

  var theme = ThemeData.light().obs;

  bool get isDarkMode=> _isDarkMode;

  set isDarkMode(bool value){
    _isDarkMode = true;
    print('dark');
  }

  void toggle(){
    if(_isDarkMode){
      theme.value= ThemeData.light();
      _isDarkMode = false;
    }else {
      theme.value = ThemeData.dark();
      _isDarkMode = true;
    }
  }

  // void toggle (){
  //   _i
  // }

}