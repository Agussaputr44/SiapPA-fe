import 'package:flutter/material.dart';

class FiltersProvider extends ChangeNotifier {
  String category = "All Categories";
  String month = "June";
  String year = "2025";

  void setCategory(String? val) {
    if (val != null && val != category) {
      category = val;
      notifyListeners();
    }
  }

  void setMonth(String? val) {
    if (val != null && val != month) {
      month = val;
      notifyListeners();
    }
  }

  void setYear(String? val) {
    if (val != null && val != year) {
      year = val;
      notifyListeners();
    }
  }
}