import 'package:flutter/widgets.dart';

class AppSize {
  static final appHeight = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  static final appWidth = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

}