import 'package:flutter/material.dart';

class RefreshContext extends InheritedWidget {
  const RefreshContext({Key? key, required this.refresh, required Widget child})
      : super(key: key, child: child);
  final Function(Widget, String) refresh;

  void refreshWidget(Widget widget, String title) {
    refresh(widget, title);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static RefreshContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RefreshContext>();
  }
}
