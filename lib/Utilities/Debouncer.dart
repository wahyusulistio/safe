import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;
  late VoidCallback action;
  Timer _timer=new Timer(Duration(milliseconds:0), () {});

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}