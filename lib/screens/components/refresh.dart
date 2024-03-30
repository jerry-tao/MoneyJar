import 'package:flutter/material.dart';

class RefreshContext extends InheritedWidget {
  final refresh;

  RefreshContext({required this.refresh, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static RefreshContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RefreshContext>();
  }
}
