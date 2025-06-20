import 'package:flutter/widgets.dart';

/* This file contains the AppSize class which provides static properties
  * to access the height and width of the application based on the current 
 *///
class AppSize {
  static final appHeight = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  static final appWidth = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

}