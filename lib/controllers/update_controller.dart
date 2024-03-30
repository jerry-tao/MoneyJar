import 'package:flutter/material.dart';

class UpdateController with ChangeNotifier {
  void update() {
    notifyListeners();
  }
}
